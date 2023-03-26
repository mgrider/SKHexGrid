import SceneKit
import HexGrid

/// Turns out dragging on the grid requires a fair amount of code, so this
/// class is just to handle that, and keep our HexGridScene relatively focused.
final class HexGridSceneDragCoordinator: NSObject {

    private var draggingCurrentCell: Cell?

    private var draggingCurrentCellPreviousState: Cell.State = .empty

    private var draggingState: Cell.State = .empty

    public lazy var dragGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(sender:)))
        gesture.delegate = self
        return gesture
    }()

    private var scene: HexGridScene

    init(forScene scene: HexGridScene) {
        self.scene = scene
    }

    // MARK: gesture callback

    @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
        let viewPoint = sender.location(in: scene.view)
        let point = scene.convertPoint(fromView: viewPoint)
        if sender.state == .began {
            dragBegan(atPoint: point)
        } else if sender.state == .changed {
            dragChanged(toPoint: point)
        } else if sender.state == .ended {
            dragEnded(atPoint: point)
        }
    }

    // MARK: drag gesture specifics

    public func dragBegan(atPoint pos : CGPoint) {
        guard scene.config.interactionDragType != .none else { return }
        if let cell = try? scene.grid.cellAt(pos.hexPoint) {
            if cell.isBlocked {
                print( "Cell x: \(cell.coordinates.x), y: \(cell.coordinates.y), z: \(cell.coordinates.z) is blocked!")
            } else {
                print( "Cell x: \(cell.coordinates.x), y: \(cell.coordinates.y), z: \(cell.coordinates.z)")
                switch scene.config.interactionDragType {
                case .none:
                    break // handled in guard above
                case .colorChange:
                    cell.state = .touchStarted
                    scene.updateCell(cell: cell)
                case .dragExistingState:
                    if cell.state == .tapped || cell.state == .tappedASecondTime {
                        draggingState = cell.state
                        draggingCurrentCell = cell
                    }
                }
            }
        }
    }

    func dragChanged(toPoint pos : CGPoint) {
        guard scene.config.interactionDragType != .none else { return }
        if let cell = try? scene.grid.cellAt(pos.hexPoint),
           !cell.isBlocked,
           cell.state != .touchStarted
        {
            switch scene.config.interactionDragType {
            case .none:
                return
            case .colorChange:
                cell.state = .touchContinued
                scene.updateCell(cell: cell)
            case .dragExistingState:
                if let dragCell = draggingCurrentCell,
                   draggingState != .empty {
                    if cell.coordinates != dragCell.coordinates {
                        handleDragMoved(fromCell: dragCell, toCell: cell)
                    }
                }
            }
        }
    }

    func dragEnded(atPoint pos : CGPoint) {
        guard scene.config.interactionDragType != .none else { return }
        if let cell = try? scene.grid.cellAt(pos.hexPoint), !cell.isBlocked {
            switch scene.config.interactionDragType {
            case .none:
                return
            case .colorChange:
                cell.state = .touchEnded
                scene.updateCell(cell: cell)
            case .dragExistingState:
                if let dragCell = draggingCurrentCell,
                   draggingState != .empty {
                    if cell.coordinates != dragCell.coordinates {
                        handleDragMoved(fromCell: dragCell, toCell: cell)
                    }
                }
                draggingCurrentCell = nil
                draggingCurrentCellPreviousState = .empty
                draggingState = .empty
            }
        }
    }

    func handleDragMoved(fromCell: Cell, toCell: Cell) {
        fromCell.state = draggingCurrentCellPreviousState
        draggingCurrentCellPreviousState = toCell.state
        toCell.state = draggingState
        draggingCurrentCell = toCell
        scene.updateCell(cell: toCell)
        scene.updateCell(cell: fromCell)
    }
}

extension HexGridSceneDragCoordinator: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return false
    }
}

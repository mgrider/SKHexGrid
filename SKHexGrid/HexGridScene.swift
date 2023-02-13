import SpriteKit
import GameplayKit
import HexGrid

class HexGridScene: SKScene {

    private var config: ConfigurationData

    private var grid: HexGrid

    private var nodesByCell = [Cell: SKShapeNode]()

    private var labelsByCell = [Cell: SKLabelNode]()

    private var spinnyNode : SKShapeNode?

    init(
        config: ConfigurationData,
        size: CGSize
    ) {
        self.config = config

        let number = Int(config.gridSizeX.rounded())
        var shape: GridShape
        switch config.gridType {
        case .custom:
            // this is not used
            shape = .hexagon(2)
        case .rectangle:
            let secondary = Int(config.gridSizeY.rounded())
            shape = .rectangle(number, secondary)
        case .hexagon:
            shape = .hexagon(number)
        case .irregularHexagon:
            let secondary = Int(config.gridSizeY.rounded())
            shape = .irregularHexagon(number, secondary)
        case .parallelogram:
            let secondary = Int(config.gridSizeY.rounded())
            shape = .parallelogram(number, secondary)
        case .triangle:
            shape = .triangle(number)
        }

        let orientation: Orientation = config.pointsUp ? .pointyOnTop : .flatOnTop
        let offset: OffsetLayout = config.offsetEven ? .even : .odd

        if config.gridType == .custom {
            let cellSet: Set<Cell> = try! Set([
                CubeCoordinates(x:  1, y: -1, z:  0),
                CubeCoordinates(x:  0, y: -1, z:  1),
                CubeCoordinates(x:  1, y:  1, z: -2),
                CubeCoordinates(x: -1, y:  1, z:  0),
                CubeCoordinates(x:  0, y:  1, z: -1),
                CubeCoordinates(x:  1, y:  0, z: -1),
                CubeCoordinates(x:  3, y: -3, z:  0),
            ].map { Cell($0) })
            self.grid = HexGrid(
                cells: cellSet,
                orientation: orientation,
                offsetLayout: offset,
                hexSize: HexSize(width: 100.0, height: 100.0),
                origin: Point(x: 0.0, y: 0.0)
            )
            self.grid.fitGrid(in: size.hexSize)
        } else {
            self.grid = HexGrid(
                shape: shape,
                pixelSize: size.hexSize,
                orientation: orientation,
                offsetLayout: offset
            )
        }

        super.init(size: size)

        backgroundColor = UIColor(config.colorForBackground)
    }

    private func updateCell(cell: Cell) {
        var cellColor: UIColor
        guard let shapeNode = nodesByCell[cell] else {
            print("could not find cell")
            return
        }
        let state = cell.state
        switch state {
        case .empty:
            cellColor = UIColor(config.colorForStateEmpty)
        case .tapped:
            cellColor = UIColor(config.colorForStateTapped)
        case .touchStarted:
            cellColor = UIColor(config.colorForStateDragBegan)
        case .touchContinued:
            cellColor = UIColor(config.colorForStateDragContinued)
        case .touchEnded:
            cellColor = UIColor(config.colorForStateDragEnded)
        }
        shapeNode.fillColor = cellColor
    }

    private func updateCellColor(cell: Cell, color: UIColor) {
        guard let shapeNode = nodesByCell[cell] else {
            print("could not find cell")
            return
        }
        shapeNode.fillColor = color
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {

        for cell in grid.cells {
            let polyCorners = grid.polygonCorners(for: cell)
            var corners: [CGPoint] = polyCorners.map { $0.cgPoint }
            corners.append(polyCorners[0].cgPoint)
            let shapeNode = SKShapeNode(
                points: &corners,
                count: corners.count)
            shapeNode.strokeColor = UIColor(config.colorForHexagonBorder)

            nodesByCell[cell] = shapeNode
            addChild(shapeNode)

            if config.showsCoordinates != .none {
                let center = grid.pixelCoordinates(for: cell)
                var cellText: String
                switch config.showsCoordinates {
                case .none:
                    cellText = ""
                case .cube:
                    cellText = "\(cell.coordinates.x), \(cell.coordinates.y)\n  \(cell.coordinates.z)"
                case .offset:
                    let offset = cell.coordinates.toOffset(orientation: grid.orientation, offsetLayout: grid.offsetLayout)
                    cellText = "\(offset.column), \(offset.row)"
                case .axial:
                    let axial = cell.coordinates.toAxial()
                    cellText = "\(axial.q), \(axial.r)"
                }
                let label = SKLabelNode(text: cellText)
                label.fontName = "Helvetica"
                label.fontSize = config.coordinateLabelFontSize
                label.fontColor = UIColor(config.colorForCoordinateLabels)
                label.numberOfLines = 2
                label.horizontalAlignmentMode = .center
                label.verticalAlignmentMode = .center
                label.position = center.cgPoint

                labelsByCell[cell] = label
                addChild(label)
            }

            updateCell(cell: cell)
        }

        switch config.initialShading {
        case .none:
            break
        case .edges:
            colorEdgeCells()
        case .rings:
            colorEveryOtherRingOfCells()
        case .threeColor:
            colorBoardWithThreeColors()
        }

        // Create shape node to use during drag interaction
        let w = (self.size.width + self.size.height) * 0.05
        let spinnyNode = SKShapeNode(circleOfRadius: w)
        spinnyNode.lineWidth = 2.5
        spinnyNode.run(SKAction.sequence([
            SKAction.scale(by: 0.01, duration: 0.5),
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.removeFromParent(),
        ]))
        self.spinnyNode = spinnyNode

        // add some gesture recognizers
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        view.gestureRecognizers = [tapGesture, dragGesture]
    }

    func colorEdgeCells() {
        let color: UIColor = UIColor(config.colorForStateEmptySecondary)
        for cell in grid.cells {
            if let neighbors = try? grid.neighbors(for: cell),
               neighbors.count != 6 {
                updateCellColor(cell: cell, color: color)
            }
        }
    }

    func colorEveryOtherRingOfCells() {
        let color1: UIColor = UIColor(config.colorForStateEmptySecondary)
        let color2: UIColor = UIColor(config.colorForStateEmpty)
        var neighborsForCell = [Cell: Set<Cell>]()
        var timeForColor1 = true
        var color = color1
        var touchedCells = Set<Cell>()
        for cell in grid.cells {
            if let neighbors = try? grid.neighbors(for: cell) {
                neighborsForCell[cell] = neighbors
                if neighbors.count != 6 {
                    updateCellColor(cell: cell, color: color)
                    touchedCells.insert(cell)
                }
            }
        }
        // second ring should be cells that touch the edges of the last
        var ringCells = Set<Cell>(touchedCells)
        var secondRingCells = Set<Cell>()
        while touchedCells.count < grid.cells.count {
            color = timeForColor1 ? color1 : color2
            for cell in grid.cells {
                if touchedCells.contains(cell) { continue }
                if let neighbors = neighborsForCell[cell] {
                    for nCell in neighbors {
                        if ringCells.contains(nCell) {
                            secondRingCells.insert(cell)
                            updateCellColor(cell: cell, color: color)
                            break
                        }
                    }
                }
            }
            touchedCells.formUnion(ringCells)
            ringCells.removeAll()
            ringCells.formUnion(secondRingCells)
            secondRingCells.removeAll()
            timeForColor1.toggle()
        }
    }

    func colorBoardWithThreeColors() {
        for cell in grid.cells {
            let axial = cell.coordinates.toAxial()
            let modX = axial.r % 3
            switch modX {
            case 1, -2:
                let modY = (axial.q + 2) % 3
                updateCellColor(cell: cell, color: colorForBoardWithThreeColors(at: modY))
            case -1, 2:
                let modY = (axial.q + 1) % 3
                updateCellColor(cell: cell, color: colorForBoardWithThreeColors(at: modY))
            default: // should only be case 0
                let modY = axial.q % 3
                updateCellColor(cell: cell, color: colorForBoardWithThreeColors(at: modY))
            }
        }
    }

    func colorForBoardWithThreeColors(at index: Int) -> UIColor {
        if index >= 0, index < 3 {
            let colors = [
                UIColor(config.colorForStateEmpty),
                UIColor(config.colorForStateEmptySecondary),
                UIColor(config.colorForStateEmptyTertiary),
            ]
            return colors[index]
        } else if index < 0, index > -3 {
            let colors = [
                UIColor(config.colorForStateEmptyTertiary),
                UIColor(config.colorForStateEmptySecondary),
                UIColor(config.colorForStateEmpty),
            ]
            return colors[abs(index)-1]
        } else {
            return .systemOrange
        }
    }

    // MARK: handling input

    /// Note: to support taps as well as drags, we're using gesture recognizers as opposed to

    func tapped(atPoint pos: CGPoint) {
        if let cell = try? grid.cellAt(pos.hexPoint) {
            if cell.isBlocked {
                print( "Cell x: \(cell.coordinates.x), y: \(cell.coordinates.y), z: \(cell.coordinates.z) is blocked!")
            } else {
                print( "Cell tapped - x: \(cell.coordinates.x), y: \(cell.coordinates.y), z: \(cell.coordinates.z)")
                if cell.state == .tapped {
                    cell.state = .empty
                } else {
                    cell.state = .tapped
                }
                updateCell(cell: cell)
            }
        }
    }

    func touchDown(atPoint pos : CGPoint) {
        if let cell = try? grid.cellAt(pos.hexPoint) {
            if cell.isBlocked {
                print( "Cell x: \(cell.coordinates.x), y: \(cell.coordinates.y), z: \(cell.coordinates.z) is blocked!")
            } else {
                print( "Cell x: \(cell.coordinates.x), y: \(cell.coordinates.y), z: \(cell.coordinates.z)")
                cell.state = .touchStarted
                updateCell(cell: cell)
            }
        }
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }

    func touchMoved(toPoint pos : CGPoint) {
        if let cell = try? grid.cellAt(pos.hexPoint),
           !cell.isBlocked,
           cell.state != .touchStarted
        {
            cell.state = .touchContinued
            updateCell(cell: cell)
        }
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }

    func touchUp(atPoint pos : CGPoint) {
        if let cell = try? grid.cellAt(pos.hexPoint), !cell.isBlocked {
            cell.state = .touchEnded
            updateCell(cell: cell)
        }
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }

    // newer gesture-based input

    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let point = sender.location(in: view)
            let pointInScene = convertPoint(fromView: point)
            tapped(atPoint: pointInScene)
        }
    }

    @objc func handlePan(sender: UIPanGestureRecognizer) {
        let viewPoint = sender.location(in: view)
        let point = convertPoint(fromView: viewPoint)
        if sender.state == .began {
            touchDown(atPoint: point)
        } else if sender.state == .changed {
            touchMoved(toPoint: point)
        } else if sender.state == .ended {
            touchUp(atPoint: point)
        }
    }


    // old way, handling each touch individually

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches {
//            if t.tapCount == 1 {
//                self.tapped(atPoint: t.location(in: self))
//            } else {
//                self.touchUp(atPoint: t.location(in: self))
//            }
//        }
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }

    // MARK: update loop for realtime games

//    override func update(_ currentTime: TimeInterval) {
//        // Called before each frame is rendered
//    }
}

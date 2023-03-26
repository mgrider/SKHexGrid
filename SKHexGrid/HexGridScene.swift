import SpriteKit
import GameplayKit
import HexGrid

class HexGridScene: SKScene {

    // MARK: scene properties

    private(set) var config: ConfigurationData

    private var dragCoordinator: HexGridSceneDragCoordinator?

    private var emptyColorsByCell = [Cell: UIColor]()

    private(set) var grid: HexGrid

    private var labelsByCell = [Cell: SKLabelNode]()

    private var nodesByCell = [Cell: SKShapeNode]()

    private var nodesOnTopOfCell = [Cell: SKShapeNode]()

    // MARK: init

    init(
        config: ConfigurationData,
        size: CGSize
    ) {
        self.config = config

        let number = Int(config.gridSizeX.rounded())
        var shape: GridShape
        switch config.gridType {
        case .custom:
            // this shape value is not used
            shape = .hexagon(2)
        case .rectangle:
            let secondary = Int(config.gridSizeY.rounded())
            shape = .rectangle(number, secondary)
        case .irregularHexagon:
            let secondary = Int(config.gridSizeY.rounded())
            shape = .irregularHexagon(number, secondary)
        case .extendedHexagon:
            let secondary = Int(config.gridSizeY.rounded())
            shape = .elongatedHexagon(number, secondary)
        case .parallelogram:
            let secondary = Int(config.gridSizeY.rounded())
            shape = .parallelogram(number, secondary)
        case .triangle:
            shape = .triangle(number)
        }

        let orientation: Orientation = config.pointsUp ? .pointyOnTop : .flatOnTop
        let offset: OffsetLayout = config.offsetEven ? .even : .odd

        // need to subtract the border width from our total grid size
        var hexSize = size.hexSize
        hexSize.height -= (config.borderWidth * 2)
        hexSize.width -= (config.borderWidth * 2)

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
            self.grid.fitGrid(in: hexSize)
        } else {
            self.grid = HexGrid(
                shape: shape,
                pixelSize: hexSize,
                orientation: orientation,
                offsetLayout: offset
            )
        }

        // need to offset the "origin" AFTER initial grid setup,
        // so all our pixel calculations are correct while drawing the border.
        grid.origin = grid.origin.offset(by: .init(x: config.borderWidth, y: config.borderWidth))

        print("HexGrid setup complete, \(grid.cells.count) cells")

        super.init(size: size)

        backgroundColor = UIColor(config.colorForBackground)
        dragCoordinator = HexGridSceneDragCoordinator(forScene: self)

        // see `didMove(to view: SKView)` for generation of nodes
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: updating cell states

    private func addOrUpdateNodeOnTopOfCell(cell: Cell, tap2: Bool) {
        let color = tap2 ? UIColor(config.colorForStateTapped2) : UIColor(config.colorForStateTapped)
        if let stone = nodesOnTopOfCell[cell] {
            stone.fillColor = color
        } else {
            let newType = tap2 ? config.interactionTap2Type : config.interactionTapType
            switch newType {
            case .shapeAddStone:
                let newNode = SKShapeNode.stoneNode(withRadius: grid.hexSize.height / 2)
                newNode.position = grid.pixelCoordinates(for: cell).cgPoint
                newNode.fillColor = color
                self.addChild(newNode)
                nodesOnTopOfCell[cell] = newNode
            case .colorChange, .none:
                break
            }
        }
    }

    private func removeNodeOnTopOfCell(cell: Cell) {
        guard let node = nodesOnTopOfCell[cell] else {
            return
        }
        node.run(SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.25),
            SKAction.removeFromParent(),
        ]))
        nodesOnTopOfCell[cell] = nil
    }

    func updateCell(cell: Cell) {
        var cellColor: UIColor
        guard let shapeNode = nodesByCell[cell] else {
            print("could not find cell")
            return
        }
        let state = cell.state
        switch state {
        case .empty:
            cellColor = emptyColorsByCell[cell] ?? UIColor(config.colorForStateEmpty)
            if let stone = nodesOnTopOfCell[cell] {
                stone.run(SKAction.sequence([
                    SKAction.fadeOut(withDuration: 0.25),
                    SKAction.removeFromParent(),
                ]))
                nodesOnTopOfCell[cell] = nil
            }
        case .tapped:
            switch config.interactionTapType {
            case .none:
                return
            case .colorChange:
                cellColor = UIColor(config.colorForStateTapped)
                removeNodeOnTopOfCell(cell: cell)
            case .shapeAddStone:
                addOrUpdateNodeOnTopOfCell(cell: cell, tap2: false)
                cellColor = emptyColorsByCell[cell] ?? UIColor(config.colorForStateEmpty)
            }
        case .tappedASecondTime:
            switch config.interactionTap2Type {
            case .none:
                return
            case .colorChange:
                cellColor = UIColor(config.colorForStateTapped2)
                removeNodeOnTopOfCell(cell: cell)
            case .shapeAddStone:
                addOrUpdateNodeOnTopOfCell(cell: cell, tap2: true)
                cellColor = emptyColorsByCell[cell] ?? UIColor(config.colorForStateEmpty)
            }
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

    // MARK: scene overrides

    override func didMove(to view: SKView) {

        for cell in grid.cells {
            let polyCorners = grid.polygonCorners(for: cell)
            var corners: [CGPoint] = polyCorners.map { $0.cgPoint }
            corners.append(corners[0])
            let shapeNode = SKShapeNode(
                points: &corners,
                count: corners.count)
            shapeNode.strokeColor = UIColor(config.colorForHexagonBorder)
            shapeNode.lineWidth = config.borderWidth.rounded()

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

            if config.initialShading == .none {
                emptyColorsByCell[cell] = UIColor(config.colorForStateEmpty)
            }
        }

        switch config.initialShading {
        case .none:
            break
        case .edges:
            colorEdgeCells()
        case .edgesTwoColor:
            colorEdgeCellsWithTwoColors()
        case .random:
            colorCellsRandomly()
        case .rings:
            colorEveryOtherRingOfCells(useThreeColors: false)
        case .ringsThreeColor:
            colorEveryOtherRingOfCells(useThreeColors: true)
        case .threeColor:
            colorBoardWithThreeColors()
        }

        for cell in grid.cells {
            updateCell(cell: cell)
        }

        // add some gesture recognizers
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        guard let dragGesture = dragCoordinator?.dragGesture else { return }
        view.gestureRecognizers = [tapGesture, dragGesture]
    }

    override func willMove(from view: SKView) {
        view.gestureRecognizers?.removeAll()
    }

    // MARK: empty cell colors and shading

    func colorCellsRandomly() {
        for cell in grid.cells {
            let color: UIColor = .random()
            emptyColorsByCell[cell] = color
            updateCellColor(cell: cell, color: color)
        }
    }

    func colorEdgeCells() {
        let color: UIColor = UIColor(config.colorForStateEmptySecondary)
        for cell in grid.cells {
            if let neighbors = try? grid.neighbors(for: cell),
               neighbors.count != 6 {
                emptyColorsByCell[cell] = color
                updateCellColor(cell: cell, color: color)
            }
        }
    }

    func colorEdgeCellsWithTwoColors() {
        let color: UIColor = UIColor(config.colorForStateEmptySecondary)
        let color2: UIColor = UIColor(config.colorForStateEmptyTertiary)
        var neighborsForCell = [Cell: Set<Cell>]()
        var edgeCells = Set<Cell>()
        for cell in grid.cells {
            if let neighbors = try? grid.neighbors(for: cell) {
                neighborsForCell[cell] = neighbors
                if neighbors.count < 6 {
                    emptyColorsByCell[cell] = color
                    updateCellColor(cell: cell, color: color)
                    edgeCells.insert(cell)
                }
            }
        }
        for cell in grid.cells {
            if edgeCells.contains(cell) { continue }
            if let neighbors = neighborsForCell[cell] {
                for nCell in neighbors {
                    if edgeCells.contains(nCell) {
                        emptyColorsByCell[cell] = color2
                        updateCellColor(cell: cell, color: color2)
                        break
                    }
                }
            }
        }
    }

    func colorEveryOtherRingOfCells(useThreeColors: Bool) {
        var colors: [UIColor] = [
            UIColor(config.colorForStateEmptySecondary),
            UIColor(config.colorForStateEmpty),
        ]
        if useThreeColors {
            colors.insert(UIColor(config.colorForStateEmptyTertiary), at: 1)
        }
        var neighborsForCell = [Cell: Set<Cell>]()
        var colorIndex = 0
        var color = colors[colorIndex]
        var touchedCells = Set<Cell>()
        for cell in grid.cells {
            if let neighbors = try? grid.neighbors(for: cell) {
                neighborsForCell[cell] = neighbors
                if neighbors.count != 6 {
                    emptyColorsByCell[cell] = color
                    updateCellColor(cell: cell, color: color)
                    touchedCells.insert(cell)
                }
            }
        }
        // something about this logic is wrong, I think, but this seems to work
//        colorIndex += 1
        // second ring should be cells that touch the edges of the last
        var ringCells = Set<Cell>(touchedCells)
        var secondRingCells = Set<Cell>()
        while touchedCells.count < grid.cells.count {
            color = colors[colorIndex]
            for cell in grid.cells {
                if touchedCells.contains(cell) { continue }
                if let neighbors = neighborsForCell[cell] {
                    for nCell in neighbors {
                        if ringCells.contains(nCell) {
                            secondRingCells.insert(cell)
                            emptyColorsByCell[cell] = color
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
            colorIndex += 1
            if colorIndex == colors.count { colorIndex = 0 }
        }
    }

    func colorBoardWithThreeColors() {
        for cell in grid.cells {
            let axial = cell.coordinates.toAxial()
            let modX = axial.r % 3
            switch modX {
            case 1, -2:
                let modY = (axial.q + 2) % 3
                let color = colorForBoardWithThreeColors(at: modY)
                emptyColorsByCell[cell] = color
                updateCellColor(cell: cell, color: color)
            case -1, 2:
                let modY = (axial.q + 1) % 3
                let color = colorForBoardWithThreeColors(at: modY)
                emptyColorsByCell[cell] = color
                updateCellColor(cell: cell, color: color)
            default: // should only be case 0
                let modY = axial.q % 3
                let color = colorForBoardWithThreeColors(at: modY)
                emptyColorsByCell[cell] = color
                updateCellColor(cell: cell, color: color)
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

    /// Note: to support taps as well as drags, we're using gesture recognizers as opposed to `touchesBegan`, etc.

    func tapped(atPoint pos: CGPoint) {
        guard config.interactionTapType != .none else { return }
        if let cell = try? grid.cellAt(pos.hexPoint) {
            if cell.isBlocked {
                print( "Cell x: \(cell.coordinates.x), y: \(cell.coordinates.y), z: \(cell.coordinates.z) is blocked!")
            } else {
                print( "Cell tapped - x: \(cell.coordinates.x), y: \(cell.coordinates.y), z: \(cell.coordinates.z)")
                switch cell.state {
                case .tapped:
                    if config.interactionTap2Type == .none {
                        cell.state = .empty
                    } else {
                        cell.state = .tappedASecondTime
                    }
                case .tappedASecondTime:
                    cell.state = .empty
                case .empty:
                    cell.state = .tapped
                case .touchStarted, .touchContinued, .touchEnded:
                    cell.state = .tapped
                }
                updateCell(cell: cell)
            }
        }
    }

    // MARK: gesture input handlers

    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let point = sender.location(in: view)
            let pointInScene = convertPoint(fromView: point)
            tapped(atPoint: pointInScene)
        }
    }

}

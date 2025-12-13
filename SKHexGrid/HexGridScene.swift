import SpriteKit
import GameplayKit
import HexGrid

class HexGridScene: SKScene {

    // MARK: scene properties

    private(set) var config: HexGridConfig

    private var dragCoordinator: HexGridSceneDragCoordinator?

    private var emptyColorsByCell = [Cell: UIColor]()

    private(set) var grid: HexGrid

    private var labelsByCell = [Cell: SKLabelNode]()

    private var nodesByCell = [Cell: SKShapeNode]()

    private var nodesOnTopOfCell = [Cell: SKShapeNode]()

    // MARK: init

    init(
        config: HexGridConfig,
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
            var cellSet = Set<Cell>()
            for customCell in config.customCells {
                let axial = AxialCoordinates(q: customCell.coordinateQ, r: customCell.coordinateR)
                if let cube = try? axial.toCube() {
                    cellSet.insert(Cell(cube))
                }
            }
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

        if config.showsCoordinates == .alphanumeric || config.usePositiveCoordinateValuesOnly {
            self.grid.setCellCoordinatesToPositiveValues()
            self.grid.fitGrid(in: hexSize)
        }

        // need to offset the "origin" AFTER initial grid setup,
        // so all our pixel calculations are correct while drawing the border.
        grid.origin = grid.origin.offset(by: .init(x: config.borderWidth, y: config.borderWidth))

//        print("HexGrid setup complete, \(grid.cells.count) cells")

        super.init(size: size)

        backgroundColor = config.colorForBackground.uIColor()
        dragCoordinator = HexGridSceneDragCoordinator(forScene: self)

        // see `didMove(to view: SKView)` for generation of nodes
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: updating cell states

    private func addOrUpdateNodeOnTopOfCell(cell: Cell, tap2: Bool) {
        let color = tap2 ? config.colorForStateTapped2.uIColor() : config.colorForStateTapped.uIColor()
        if let stone = nodesOnTopOfCell[cell] {
            stone.fillColor = color
        } else {
            let newType = tap2 ? config.interactionTap2Type : config.interactionTapType
            switch newType {
            case .stone:
                let newNode = SKShapeNode.stoneNode(withRadius: grid.hexSize.height / 2)
                newNode.position = grid.pixelCoordinates(for: cell).cgPoint
                newNode.fillColor = color
                self.addChild(newNode)
                nodesOnTopOfCell[cell] = newNode
            case .color, .none:
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
            cellColor = emptyColorsByCell[cell] ?? config.colorForStateEmpty.uIColor()
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
            case .color:
                cellColor = config.colorForStateTapped.uIColor()
                removeNodeOnTopOfCell(cell: cell)
            case .stone:
                addOrUpdateNodeOnTopOfCell(cell: cell, tap2: false)
                cellColor = emptyColorsByCell[cell] ?? config.colorForStateEmpty.uIColor()
            }
        case .tappedASecondTime:
            switch config.interactionTap2Type {
            case .none:
                return
            case .color:
                cellColor = config.colorForStateTapped2.uIColor()
                removeNodeOnTopOfCell(cell: cell)
            case .stone:
                addOrUpdateNodeOnTopOfCell(cell: cell, tap2: true)
                cellColor = emptyColorsByCell[cell] ?? config.colorForStateEmpty.uIColor()
            }
        case .touchStarted:
            cellColor = config.colorForStateDragBegan.uIColor()
        case .touchContinued:
            cellColor = config.colorForStateDragContinued.uIColor()
        case .touchEnded:
            cellColor = config.colorForStateDragEnded.uIColor()
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
            shapeNode.strokeColor = config.colorForHexagonBorder.uIColor()
            shapeNode.lineWidth = config.borderWidth.rounded()

            nodesByCell[cell] = shapeNode
            addChild(shapeNode)

            let center = grid.pixelCoordinates(for: cell)

            if config.drawCenterPoint {
                let pointNode = SKShapeNode(circleOfRadius: CGFloat(config.drawCenterPointDiameter / 2.0))
                pointNode.fillColor = config.drawCenterPointColor.uIColor()
                pointNode.lineWidth = 0
                pointNode.position = center.cgPoint
                addChild(pointNode)
            }

            if config.showsCoordinates != .none {
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
                case .alphanumeric:
                    let axial = cell.coordinates.toAxial()
                    cellText = "\(axial.q.alphabeticalRepresentation().uppercased())\(axial.r)"
                }
                let label = SKLabelNode(text: cellText)
                label.fontName = "Helvetica"
                label.fontSize = config.coordinateLabelFontSize
                label.fontColor = config.colorForCoordinateLabels.uIColor()
                label.numberOfLines = 2
                label.horizontalAlignmentMode = .center
                label.verticalAlignmentMode = .center
                label.position = center.cgPoint
                label.zPosition = 100

                labelsByCell[cell] = label
                addChild(label)
            }

            if config.initialShading == .none {
                emptyColorsByCell[cell] = config.colorForStateEmpty.uIColor()
            }
        }

        switch config.initialShading {
        case .none:
            break
        case .edges:
            colorEdgeCells()
        case .edgesTwoColor:
            colorEdgeCellsWithTwoColors()
        case .periodic1:
            colorPeriodicBackground(withInterval: 2)
        case .periodic2:
            colorPeriodicBackground(withInterval: 3)
        case .random:
            colorCellsRandomly()
        case .rings:
            colorEveryOtherRingOfCells(useThreeColors: false)
        case .ringsThreeColor:
            colorEveryOtherRingOfCells(useThreeColors: true)
        case .threeColor:
            colorBoardWithThreeColors()
        }

        if config.drawLinesBetweenCells {
            drawLinesBetweenCells()
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
        let color: UIColor = config.colorForStateEmptySecondary.uIColor()
        for cell in grid.cells {
            if let neighbors = try? grid.neighbors(for: cell),
               neighbors.count != 6 {
                emptyColorsByCell[cell] = color
                updateCellColor(cell: cell, color: color)
            }
        }
    }

    func colorEdgeCellsWithTwoColors() {
        let color: UIColor = config.colorForStateEmptySecondary.uIColor()
        let color2: UIColor = config.colorForStateEmptyTertiary.uIColor()
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
            config.colorForStateEmptySecondary.uIColor(),
            config.colorForStateEmpty.uIColor(),
        ]
        if useThreeColors {
            colors.insert(config.colorForStateEmptyTertiary.uIColor(), at: 1)
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
                config.colorForStateEmpty.uIColor(),
                config.colorForStateEmptySecondary.uIColor(),
                config.colorForStateEmptyTertiary.uIColor(),
            ]
            return colors[index]
        } else if index < 0, index > -3 {
            let colors = [
                config.colorForStateEmptyTertiary.uIColor(),
                config.colorForStateEmptySecondary.uIColor(),
                config.colorForStateEmpty.uIColor(),
            ]
            return colors[abs(index)-1]
        } else {
            return .systemOrange
        }
    }

    func colorPeriodicBackground(withInterval: Int) {
        for cell in grid.cells {
            let axial = cell.coordinates.toAxial()
            let modX = axial.r % withInterval
            let modY = axial.q % withInterval
            if modX == 0 && modY == 0 {
                let color = config.colorForStateEmptySecondary.uIColor()
                emptyColorsByCell[cell] = color
                updateCellColor(cell: cell, color: color)
            } else {
                let color = config.colorForStateEmpty.uIColor()
                emptyColorsByCell[cell] = color
                updateCellColor(cell: cell, color: color)
            }
        }
    }

    // MARK: drawing lines between cells

    func drawLinesBetweenCells() {
        var points: [CGPoint] = []
        var alreadyDrawnPoints: [CGPoint] = []
        var cellPoint: CGPoint
        for cell in grid.cells {
            cellPoint = grid.pixelCoordinates(for: cell).cgPoint
            if let neighbors = try? grid.neighbors(for: cell) {
                for nCell in neighbors {
                    points.removeAll(keepingCapacity: true)
                    points.append(cellPoint)
                    let nPoint = grid.pixelCoordinates(for: nCell).cgPoint
                    if alreadyDrawnPoints.contains(nPoint) {
                        continue
                    }
                    points.append(nPoint)
                    let linearShapeNode = SKShapeNode(points: &points,
                                                      count: points.count)
                    linearShapeNode.strokeColor = config.drawLinesBetweenCellsColor.uIColor()
                    linearShapeNode.lineWidth = config.drawLinesBetweenCellsWidth
                    addChild(linearShapeNode)
                }
            }
            alreadyDrawnPoints.append(cellPoint)
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

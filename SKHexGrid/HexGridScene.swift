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

        let number = Int(config.associatedNumber.rounded())
        var shape: GridShape
        switch config.gridType {
        case .custom:
            // this is not used
            shape = .hexagon(2)
        case .rectangle:
            shape = .rectangle(number, number)
        case .hexagon:
            shape = .hexagon(number)
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

        backgroundColor = .systemPink
    }

    private func updateCell(cell: Cell) {
        var cellColor: UIColor
        guard let shapeNode = nodesByCell[cell] else {
            print("could not find cell")
            return
        }
        if cell.attributes["isHighlighted"] == true {
            cellColor = UIColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 1)
        } else if cell.isBlocked {
            cellColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        } else {
            cellColor = .lightGray
        }
        shapeNode.fillColor = cellColor
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
                label.fontSize = 10
                label.fontColor = .black
                label.numberOfLines = 2
                label.horizontalAlignmentMode = .center
                label.verticalAlignmentMode = .center
                label.position = center.cgPoint

                labelsByCell[cell] = label
                addChild(label)
            }

            updateCell(cell: cell)
        }

        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        self.spinnyNode = SKShapeNode(circleOfRadius: w)

        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5

//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.scale(by: 0.01, duration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }


    func touchDown(atPoint pos : CGPoint) {
        if let cell = try? grid.cellAt(pos.hexPoint) {
            if cell.isBlocked {
                print( "Cell x: \(cell.coordinates.x), y: \(cell.coordinates.y), z: \(cell.coordinates.z) is blocked!")
            } else {
                print( "Cell x: \(cell.coordinates.x), y: \(cell.coordinates.y), z: \(cell.coordinates.z)")
                cell.toggleHighlight()
                updateCell(cell: cell)
            }
        }
        else if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }

    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }

    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }


    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

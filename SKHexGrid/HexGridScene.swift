import SpriteKit
import GameplayKit
import HexGrid

class HexGridScene: SKScene {

    private var grid: HexGrid
    private var gridShape: GridShape

    private var nodesByCell = [Cell: SKShapeNode]()

    private var spinnyNode : SKShapeNode?

    init(
        config: ConfigurationData,
        size: CGSize
    ) {

        let number = Int(config.associatedNumber)
        var shape: GridShape
        switch config.gridType {
        case .rectangle:
            shape = .rectangle(number, number)
        case .hexagon:
            shape = .hexagon(number)
        case .triangle:
            shape = .triangle(number)
        }

        self.gridShape = shape

        let orientation: Orientation = config.pointsUp ? .pointyOnTop : .flatOnTop

        self.grid = HexGrid(
            shape: gridShape,
            gridSize: size.hexSize,
            orientation: orientation
        )

        // set a reasonable origin based on grid type
        // TODO: move this into a helper function, or maybe into the convenience init
        switch gridShape {
        case .rectangle:
            if config.pointsUp {
                // TODO: this one is totally wrong. Probably needs to be rotated.
                grid.origin = Point(x: grid.hexSize.width, y: size.height - grid.hexSize.height)
            } else {
                grid.origin = Point(x: grid.hexSize.width, y: size.height - grid.hexSize.height)
            }
        case .hexagon:
            grid.origin = Point(x: size.width / 2.0, y: size.height / 2.0)
        case .triangle:
            if config.pointsUp {
                let y = size.height - grid.hexSize.height
                grid.origin = Point(x: size.width / 2.0, y: y)
            } else {
                // TODO: this doesn't work... not sure why... will need to figure it out
                grid.origin = Point(x: grid.hexSize.width, y: size.height + grid.hexSize.height)
            }
        }

        super.init(size: size)

        backgroundColor = .clear
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
            updateCell(cell: cell)

            addChild(shapeNode)
        }

        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        self.spinnyNode = SKShapeNode(circleOfRadius: w)

        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5

//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.25),
                                              SKAction.scale(by: 0.01, duration: 0.5),
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

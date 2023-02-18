import SpriteKit
import HexGrid

class SimpleHexGridScene: SKScene {

    override func didMove(to view: SKView) {

        backgroundColor = .black

        // we'll use this `GridShape` to generate a 5x5x5 hexagon grid
        let shape: GridShape = .hexagon(5)

        // the HexGrid initializer will use this size to determine the size of each cell
        let hexSize = size.hexSize

        let grid = HexGrid(
            shape: shape,
            pixelSize: hexSize
        )

        for cell in grid.cells {

            // get the 6 corners for the hexagon
            let polyCorners = grid.polygonCorners(for: cell)
            var corners: [CGPoint] = polyCorners.map { $0.cgPoint }

            // we need to complete the shape by adding the initial point again
            corners.append(polyCorners[0].cgPoint)

            // create a SKShapeNode for the hexagon and add it to the scene
            let shapeNode = SKShapeNode(
                points: &corners,
                count: corners.count)
            shapeNode.strokeColor = .white
            shapeNode.fillColor = .random()
            addChild(shapeNode)
        }

    }

}

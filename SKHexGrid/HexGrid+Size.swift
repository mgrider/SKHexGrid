import CoreGraphics
import HexGrid

extension HexGrid {

    /// Convenience initializer that takes a `gridSize` parameter and computes `hexSize` from that.
    convenience init(
        shape: GridShape,
        gridSize: HexSize = HexSize(width: 100.0, height: 100.0),
        orientation: Orientation = Orientation.pointyOnTop,
        offsetLayout: OffsetLayout = OffsetLayout.even,
        origin: Point = Point(x: 0, y: 0),
        attributes: [String: Attribute] = [String: Attribute]()
    ) {
        var hexWidth: Double = 10
        var hexHeight: Double = 10
        switch shape {
        case .rectangle(let width, let height):
            switch orientation {
            case .pointyOnTop:
                // TODO: not sure how this is supposed to work, probably need to rotate
                break
            case .flatOnTop:
                let numberOfHalves = Double((height * 2) + 1)
                hexHeight = (gridSize.height / numberOfHalves) * 2.0
                hexWidth = hexHeight / 3.squareRoot()
                hexHeight = hexWidth
            }
        case .hexagon(let side):
            let totalAcross = (CGFloat(side) * 2.0) - 1.0
            switch orientation {
            case .pointyOnTop:
                hexWidth = gridSize.width / totalAcross
                hexHeight = hexWidth / 3.squareRoot()
                hexWidth = hexHeight
            case .flatOnTop:
                hexHeight = gridSize.height / totalAcross
                hexWidth = hexHeight / 3.squareRoot()
                hexHeight = hexWidth
            }
        case .triangle(let dimension):
            let totalAcross = CGFloat(dimension)
            switch orientation {
            case .pointyOnTop:
                hexWidth = gridSize.width / totalAcross
                hexHeight = hexWidth / 3.squareRoot()
                hexWidth = hexHeight
            case .flatOnTop:
                hexHeight = gridSize.height / totalAcross
                hexWidth = hexHeight / 3.squareRoot()
                hexHeight = hexWidth
            }
        }
        self.init(
            shape: shape,
            orientation: orientation,
            offsetLayout: offsetLayout,
            hexSize: HexSize(width: hexWidth, height: hexHeight),
            origin: origin,
            attributes: attributes)
    }
}


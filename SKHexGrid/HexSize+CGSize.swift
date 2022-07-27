import CoreGraphics
import HexGrid

extension HexSize {
    public var cgSize : CGSize {
        return CGSize(width: width, height: height)
    }
}

extension CGSize {
    public var hexSize : HexSize {
        return HexSize(width: width, height: height)
    }
}

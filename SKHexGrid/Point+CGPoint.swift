import SwiftUI
import HexGrid

extension Point {
    public var cgPoint : CGPoint {
        return CGPoint(x: x, y: y)
    }
}

extension CGPoint {
    public var hexPoint : Point {
        return Point(x: x, y: y)
    }
}

import Foundation
import SwiftUI
import HexGrid

class ConfigurationData: ObservableObject {

    enum GridCoordinateType: String, Hashable, Codable {
        case none
        case cube
        case offset
        case axial
    }
    enum GridType: String, Hashable, Codable {
        case custom
        case rectangle
        //        case hexagon
        case irregularHexagon
        case parallelogram
        case triangle
    }
    enum GridInitialShading: String, Hashable, Codable {
        case none
        case edges
        case edgesTwoColor
        case random
        case rings
        //        case ringsTwoColor
        case threeColor
    }

    // grid config
    @Published var gridSizeX: Double = 3
    @Published var gridSizeY: Double = 3
    @Published var gridType: GridType = .irregularHexagon
    @Published var pointsUp = true
    @Published var offsetEven = true

    // coordinates
    @Published var showsCoordinates: GridCoordinateType = .axial
    @Published var colorForCoordinateLabels: Color = .black
    @Published var coordinateLabelFontSize: Double = 10

    // colors
    @Published var colorForBackground: Color = .black
    @Published var colorForHexagonBorder: Color = .white
    @Published var colorForStateEmpty: Color = Color(UIColor.lightGray)
    @Published var colorForStateTapped: Color = Color(UIColor.systemOrange)
    @Published var colorForStateDragBegan: Color = Color(red: 59/256, green: 172/256, blue: 182/256)
    @Published var colorForStateDragContinued: Color = Color(red: 130/256, green: 219/256, blue: 216/256)
    @Published var colorForStateDragEnded: Color = Color(red: 179/256, green: 232/256, blue: 229/256)

    // misc
    @Published var borderWidth:Double = 1
    @Published var initialShading: GridInitialShading = .threeColor
    @Published var colorForStateEmptySecondary: Color = Color(.gray)
    @Published var colorForStateEmptyTertiary: Color = Color(red: 0.8, green: 0.8, blue: 0.8)
    @Published var showYellowSecondaryGrid = false

    init(
        number: Double = 3,
        gridType: GridType = .irregularHexagon
    ) {
        self.gridSizeX = number
        self.gridType = gridType
    }
}

//extension ConfigurationData: Encodable {
    // TODO
//}

import Foundation
import SwiftUI
import HexGrid

@Observable
class ConfigurationData {

    struct GridCoordinateItem: Identifiable, Equatable {
        var id = UUID()
        var coordinateQ: Int
        var coordinateR: Int
    }
    enum GridCoordinateType: String, Hashable, Codable, CaseIterable {
        case none
        case cube
        case offset
        case axial
        case alphanumeric
    }
    enum GridType: String, Hashable, Codable, CaseIterable {
        case custom
        case rectangle
        case irregularHexagon
        case extendedHexagon
        case parallelogram
        case triangle
    }
    enum GridInitialShading: String, Hashable, Codable, CaseIterable {
        case none
        case edges
        case edgesTwoColor
        case periodic1
        case periodic2
        case random
        case rings
        case ringsThreeColor
        case threeColor
    }
    enum GridCellTapInteractionType: String, Hashable, Codable {
        case none
        case colorChange
//        case shapeAddCircle
//        case shapeAddSquare
        case shapeAddStone
//        case shapeAddTriangle
    }
    enum GridCellDragInteractionType: String, Hashable, Codable {
        case none
        case colorChange
        case dragExistingState
    }

    // grid config
    var gridSizeX: Double = 3
    var gridSizeY: Double = 3
    var gridType: GridType = GridType.irregularHexagon
    var pointsUp = true
    var offsetEven = true

    // custom cells
    var customCells: [GridCoordinateItem]

    // coordinates
    var showsCoordinates: GridCoordinateType = GridCoordinateType.axial
    var colorForCoordinateLabels: Color = Color.black
    var coordinateLabelFontSize: Double = 10
    var usePositiveCoordinateValuesOnly: Bool = false

    // entire scene background color
    var colorForBackground: Color = Color.black

    // cell borders
    var borderWidth:Double = 1
    var colorForHexagonBorder: Color = Color.white

    // drawing center points
    var drawCenterPoint: Bool = false
    var drawCenterPointColor: Color = Color.black
    var drawCenterPointDiameter: Double = 3.0

    // drawing lines between cell center points
    var drawLinesBetweenCells: Bool = false
    var drawLinesBetweenCellsColor: Color = Color.black
    var drawLinesBetweenCellsWidth: Double = 3.0

    // interactions
    var interactionTapType: GridCellTapInteractionType = GridCellTapInteractionType.colorChange
    var colorForStateTapped: Color
    var interactionTap2Type: GridCellTapInteractionType = GridCellTapInteractionType.none
    var colorForStateTapped2: Color = Color(UIColor.systemPurple)
    var interactionDragType: GridCellDragInteractionType = GridCellDragInteractionType.none
    var colorForStateDragBegan: Color = Color(red: 59/256, green: 172/256, blue: 182/256)
    var colorForStateDragContinued: Color = Color(red: 130/256, green: 219/256, blue: 216/256)
    var colorForStateDragEnded: Color = Color(red: 179/256, green: 232/256, blue: 229/256)
    var isInteractionPinchZoomAllowed = true
    var isInteractionTwoFingerDragGridAllowed = true

    // misc
    var initialShading: GridInitialShading = GridInitialShading.threeColor
    var colorForStateEmpty: Color
    var colorForStateEmptySecondary: Color
    var colorForStateEmptyTertiary: Color = Color(red: 0.8, green: 0.8, blue: 0.8)
    var showYellowSecondaryGrid = false

    init(
        colorForStateEmpty: Color = Color(uiColor: .lightGray),
        colorForStateEmptySecondary: Color = Color(.gray),
        colorForStateTapped: Color = Color(UIColor.systemOrange),
        customCells: [GridCoordinateItem] = [
            GridCoordinateItem(coordinateQ: 0, coordinateR: 0),
            GridCoordinateItem(coordinateQ: 1, coordinateR: 0),
            GridCoordinateItem(coordinateQ: 0, coordinateR: 1),
            GridCoordinateItem(coordinateQ: 1, coordinateR: 1),
            GridCoordinateItem(coordinateQ: 1, coordinateR: 2),
            GridCoordinateItem(coordinateQ: 2, coordinateR: 2),
        ],
        number: Double = 3,
        gridType: GridType = .irregularHexagon
    ) {
        self.colorForStateEmpty = colorForStateEmpty
        self.colorForStateEmptySecondary = colorForStateEmptySecondary
        self.colorForStateTapped = colorForStateTapped
        self.customCells = customCells
        self.gridSizeX = number
        self.gridType = gridType
    }
}

extension ConfigurationData: Equatable {
    static func == (lhs: ConfigurationData, rhs: ConfigurationData) -> Bool {
        lhs.gridSizeX == rhs.gridSizeX &&
        lhs.gridSizeY == rhs.gridSizeY &&
        lhs.gridType == rhs.gridType &&
        lhs.pointsUp == rhs.pointsUp &&
        lhs.offsetEven == rhs.offsetEven &&
        lhs.customCells == rhs.customCells &&
        lhs.showsCoordinates == rhs.showsCoordinates &&
        lhs.colorForCoordinateLabels == rhs.colorForCoordinateLabels &&
        lhs.coordinateLabelFontSize == rhs.coordinateLabelFontSize &&
        lhs.usePositiveCoordinateValuesOnly == rhs.usePositiveCoordinateValuesOnly &&
        lhs.colorForBackground == rhs.colorForBackground &&
        // todo: add all the other ones here
        lhs.colorForStateEmpty == rhs.colorForStateEmpty &&
        lhs.colorForStateEmptySecondary == rhs.colorForStateEmptySecondary &&
        lhs.gridType == rhs.gridType
    }

}

//extension ConfigurationData: Encodable {
    // TODO
//}

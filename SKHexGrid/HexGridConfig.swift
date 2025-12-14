import Foundation
import HexGrid
import SwiftUI
import UIKit

final class HexGridConfig: Codable {

    struct GridCoordinateItem: Codable, Equatable {
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
    enum GridCellStateType: String, Hashable, Codable {
        case none
        case color
//        case circle
//        case square
        case stone
//        case triangle
    }
    enum GridCellDragInteractionType: String, Hashable, Codable {
        case none
        case colorChange
        case copyExistingState
        case dragExistingState
    }

    // grid config
    var gridSizeX: Double = 3
    var gridSizeY: Double = 3
    var gridType: GridType = .irregularHexagon
    var pointsUp = true
    var offsetEven = true

    // custom cells
    var customCells: [GridCoordinateItem] = [
        GridCoordinateItem(coordinateQ: 0, coordinateR: 0),
        GridCoordinateItem(coordinateQ: 1, coordinateR: 0),
        GridCoordinateItem(coordinateQ: 0, coordinateR: 1),
        GridCoordinateItem(coordinateQ: 1, coordinateR: 1),
        GridCoordinateItem(coordinateQ: 1, coordinateR: 2),
        GridCoordinateItem(coordinateQ: 2, coordinateR: 2),
    ]

    // coordinates
    var showsCoordinates: GridCoordinateType = .axial
    var colorForCoordinateLabels: ColorCodable = ColorCodable(swiftUIColor: .black)
    var coordinateLabelFontSize: Double = 10
    var usePositiveCoordinateValuesOnly: Bool = false

    // entire scene background color
    var colorForBackground: ColorCodable = ColorCodable(swiftUIColor: .black)

    // cell borders
    var borderWidth:Double = 1
    var colorForHexagonBorder: ColorCodable = ColorCodable(swiftUIColor: .white)

    // drawing center points
    var drawCenterPoint: Bool = false
    var drawCenterPointColor: ColorCodable = ColorCodable(swiftUIColor: .black)
    var drawCenterPointDiameter: Double = 3.0

    // drawing lines between cell center points
    var drawLinesBetweenCells: Bool = false
    var drawLinesBetweenCellsColor: ColorCodable = ColorCodable(swiftUIColor: .black)
    var drawLinesBetweenCellsWidth: Double = 3.0

    // interactions
    var interactionTapType: GridCellStateType = .color
    var colorForStateTapped: ColorCodable = ColorCodable(uiColor: .systemOrange)
    var interactionTap2Type: GridCellStateType = .none
    var colorForStateTapped2: ColorCodable = ColorCodable(uiColor: .systemPurple)
    var interactionDragType: GridCellDragInteractionType = .none
    var colorForStateDragBegan: ColorCodable = ColorCodable(swiftUIColor: Color(red: 59/256, green: 172/256, blue: 182/256))
    var colorForStateDragContinued: ColorCodable = ColorCodable(swiftUIColor: Color(red: 130/256, green: 219/256, blue: 216/256))
    var colorForStateDragEnded: ColorCodable = ColorCodable(swiftUIColor: Color(red: 179/256, green: 232/256, blue: 229/256))
    var isInteractionPinchZoomAllowed = true
    var isInteractionTwoFingerDragGridAllowed = true

    // misc
    var initialShading: GridInitialShading = .threeColor
    var colorForStateEmpty: ColorCodable = ColorCodable(uiColor: .lightGray)
    var colorForStateEmptySecondary: ColorCodable = ColorCodable(swiftUIColor: .gray)
    var colorForStateEmptyTertiary: ColorCodable = ColorCodable(swiftUIColor: Color(red: 0.8, green: 0.8, blue: 0.8))
    var showYellowSecondaryGrid = false

    // versioning
    var version: Int = 1

}

extension HexGridConfig: Equatable {
    static func == (lhs: HexGridConfig, rhs: HexGridConfig) -> Bool {
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
        lhs.borderWidth == rhs.borderWidth &&
        lhs.colorForHexagonBorder == rhs.colorForHexagonBorder &&
        lhs.drawCenterPoint == rhs.drawCenterPoint &&
        lhs.drawCenterPointColor == rhs.drawCenterPointColor &&
        lhs.drawCenterPointDiameter == rhs.drawCenterPointDiameter &&
        lhs.drawLinesBetweenCells == rhs.drawLinesBetweenCells &&
        lhs.drawLinesBetweenCellsColor == rhs.drawLinesBetweenCellsColor &&
        lhs.drawLinesBetweenCellsWidth == rhs.drawLinesBetweenCellsWidth &&
        lhs.interactionTapType == rhs.interactionTapType &&
        lhs.colorForStateTapped == rhs.colorForStateTapped &&
        lhs.interactionTap2Type == rhs.interactionTap2Type &&
        lhs.colorForStateTapped2 == rhs.colorForStateTapped2 &&
        lhs.interactionDragType == rhs.interactionDragType &&
        lhs.colorForStateDragBegan == rhs.colorForStateDragBegan &&
        lhs.colorForStateDragContinued == rhs.colorForStateDragContinued &&
        lhs.colorForStateDragEnded == rhs.colorForStateDragEnded &&
        lhs.isInteractionPinchZoomAllowed == rhs.isInteractionPinchZoomAllowed &&
        lhs.isInteractionTwoFingerDragGridAllowed == rhs.isInteractionTwoFingerDragGridAllowed &&
        lhs.initialShading == rhs.initialShading &&
        lhs.colorForStateEmpty == rhs.colorForStateEmpty &&
        lhs.colorForStateEmptySecondary == rhs.colorForStateEmptySecondary &&
        lhs.colorForStateEmptyTertiary == rhs.colorForStateEmptyTertiary &&
        lhs.showYellowSecondaryGrid == rhs.showYellowSecondaryGrid &&
        lhs.version == rhs.version
    }
}

import Foundation
import SwiftUI
import HexGrid

@Observable
final class ConfigurationViewData {

    // TODO: rename this ConfigurationViewData

    // grid config
    var gridSizeX: Double = 3
    var gridSizeY: Double = 3
    var gridType: HexGridConfig.GridType = .irregularHexagon
    var pointsUp = true
    var offsetEven = true

    // custom cells
    var customCells: [HexGridConfig.GridCoordinateItem] = [
        HexGridConfig.GridCoordinateItem(coordinateQ: 0, coordinateR: 0),
        HexGridConfig.GridCoordinateItem(coordinateQ: 1, coordinateR: 0),
        HexGridConfig.GridCoordinateItem(coordinateQ: 0, coordinateR: 1),
        HexGridConfig.GridCoordinateItem(coordinateQ: 1, coordinateR: 1),
        HexGridConfig.GridCoordinateItem(coordinateQ: 1, coordinateR: 2),
        HexGridConfig.GridCoordinateItem(coordinateQ: 2, coordinateR: 2),
    ]

    // coordinates
    var showsCoordinates: HexGridConfig.GridCoordinateType = .axial
    var colorForCoordinateLabels: Color = .black
    var coordinateLabelFontSize: Double = 10
    var usePositiveCoordinateValuesOnly: Bool = false

    // entire scene background color
    var colorForBackground: Color = .black

    // cell borders
    var borderWidth: Double = 1
    var colorForHexagonBorder: Color = .white

    // drawing center points
    var drawCenterPoint: Bool = false
    var drawCenterPointColor: Color = .black
    var drawCenterPointDiameter: Double = 3.0

    // drawing lines between cell center points
    var drawLinesBetweenCells: Bool = false
    var drawLinesBetweenCellsColor: Color = .black
    var drawLinesBetweenCellsWidth: Double = 3.0

    // interactions
    var interactionTapType: HexGridConfig.GridCellTapInteractionType = .colorChange
    var colorForStateTapped: Color = Color(UIColor.systemOrange)
    var interactionTap2Type: HexGridConfig.GridCellTapInteractionType = .none
    var colorForStateTapped2: Color = Color(UIColor.systemPurple)
    var interactionDragType: HexGridConfig.GridCellDragInteractionType = .none
    var colorForStateDragBegan: Color = Color(red: 59/256, green: 172/256, blue: 182/256)
    var colorForStateDragContinued: Color = Color(red: 130/256, green: 219/256, blue: 216/256)
    var colorForStateDragEnded: Color = Color(red: 179/256, green: 232/256, blue: 229/256)
    var isInteractionPinchZoomAllowed = true
    var isInteractionTwoFingerDragGridAllowed = true

    // misc
    var initialShading: HexGridConfig.GridInitialShading = .threeColor
    var colorForStateEmpty: Color = Color(UIColor.lightGray)
    var colorForStateEmptySecondary: Color = .gray
    var colorForStateEmptyTertiary: Color = Color(red: 0.8, green: 0.8, blue: 0.8)
    var showYellowSecondaryGrid = false

}

extension ConfigurationViewData: Equatable {
    static func == (lhs: ConfigurationViewData, rhs: ConfigurationViewData) -> Bool {
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
        lhs.showYellowSecondaryGrid == rhs.showYellowSecondaryGrid
    }
}

extension ConfigurationViewData {
    static func from(config: HexGridConfig) -> ConfigurationViewData {
        var data = ConfigurationViewData()
        data.gridSizeX = config.gridSizeX
        data.gridSizeY = config.gridSizeY
        data.gridType = config.gridType
        data.pointsUp = config.pointsUp
        data.offsetEven = config.offsetEven
        data.customCells = config.customCells
        data.showsCoordinates = config.showsCoordinates
        data.colorForCoordinateLabels = config.colorForCoordinateLabels.swiftUIcolor()
        data.coordinateLabelFontSize = config.coordinateLabelFontSize
        data.usePositiveCoordinateValuesOnly = config.usePositiveCoordinateValuesOnly
        data.colorForBackground = config.colorForBackground.swiftUIcolor()
        data.borderWidth = config.borderWidth
        data.colorForHexagonBorder = config.colorForHexagonBorder.swiftUIcolor()
        data.drawCenterPoint = config.drawCenterPoint
        data.drawCenterPointColor = config.drawCenterPointColor.swiftUIcolor()
        data.drawCenterPointDiameter = config.drawCenterPointDiameter
        data.drawLinesBetweenCells = config.drawLinesBetweenCells
        data.drawLinesBetweenCellsColor = config.drawLinesBetweenCellsColor.swiftUIcolor()
        data.drawLinesBetweenCellsWidth = config.drawLinesBetweenCellsWidth
        data.interactionTapType = config.interactionTapType
        data.colorForStateTapped = config.colorForStateTapped.swiftUIcolor()
        data.interactionTap2Type = config.interactionTap2Type
        data.colorForStateTapped2 = config.colorForStateTapped2.swiftUIcolor()
        data.interactionDragType = config.interactionDragType
        data.colorForStateDragBegan = config.colorForStateDragBegan.swiftUIcolor()
        data.colorForStateDragContinued = config.colorForStateDragContinued.swiftUIcolor()
        data.colorForStateDragEnded = config.colorForStateDragEnded.swiftUIcolor()
        data.isInteractionPinchZoomAllowed = config.isInteractionPinchZoomAllowed
        data.isInteractionTwoFingerDragGridAllowed = config.isInteractionTwoFingerDragGridAllowed
        data.initialShading = config.initialShading
        data.colorForStateEmpty = config.colorForStateEmpty.swiftUIcolor()
        data.colorForStateEmptySecondary = config.colorForStateEmptySecondary.swiftUIcolor()
        data.colorForStateEmptyTertiary = config.colorForStateEmptyTertiary.swiftUIcolor()
        data.showYellowSecondaryGrid = config.showYellowSecondaryGrid
        return data
    }

    func update(hexGridConfiguration config: inout HexGridConfig) {
        config.gridSizeX = gridSizeX
        config.gridSizeY = gridSizeY
        config.gridType = gridType
        config.pointsUp = pointsUp
        config.offsetEven = offsetEven
        config.customCells = customCells
        config.showsCoordinates = showsCoordinates
        config.colorForCoordinateLabels = ColorCodable(colorForCoordinateLabels)
        config.coordinateLabelFontSize = coordinateLabelFontSize
        config.usePositiveCoordinateValuesOnly = usePositiveCoordinateValuesOnly
        config.colorForBackground = ColorCodable(colorForBackground)
        config.borderWidth = borderWidth
        config.colorForHexagonBorder = ColorCodable(colorForHexagonBorder)
        config.drawCenterPoint = drawCenterPoint
        config.drawCenterPointColor = ColorCodable(drawCenterPointColor)
        config.drawCenterPointDiameter = drawCenterPointDiameter
        config.drawLinesBetweenCells = drawLinesBetweenCells
        config.drawLinesBetweenCellsColor = ColorCodable(drawLinesBetweenCellsColor)
        config.drawLinesBetweenCellsWidth = drawLinesBetweenCellsWidth
        config.interactionTapType = interactionTapType
        config.colorForStateTapped = ColorCodable(colorForStateTapped)
        config.interactionTap2Type = interactionTap2Type
        config.colorForStateTapped2 = ColorCodable(colorForStateTapped2)
        config.interactionDragType = interactionDragType
        config.colorForStateDragBegan = ColorCodable(colorForStateDragBegan)
        config.colorForStateDragContinued = ColorCodable(colorForStateDragContinued)
        config.colorForStateDragEnded = ColorCodable(colorForStateDragEnded)
        config.isInteractionPinchZoomAllowed = isInteractionPinchZoomAllowed
        config.isInteractionTwoFingerDragGridAllowed = isInteractionTwoFingerDragGridAllowed
        config.initialShading = initialShading
        config.colorForStateEmpty = ColorCodable(colorForStateEmpty)
        config.colorForStateEmptySecondary = ColorCodable(colorForStateEmptySecondary)
        config.colorForStateEmptyTertiary = ColorCodable(colorForStateEmptyTertiary)
        config.showYellowSecondaryGrid = showYellowSecondaryGrid
    }
}

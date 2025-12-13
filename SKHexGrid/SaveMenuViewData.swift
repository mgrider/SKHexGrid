import SwiftUI
import HexGrid

@Observable
class SaveMenuViewData {

    enum PresetLoadType: String, CaseIterable {
        case simpleExample
        case defaultGray
        case randomColorParallelogram
        case whiteBorderlessEdges
        case blueExtendedTall
        case pinkTriangle
        case goBoardSquare
        case centerPoints
        case centerPointsAndLines
        case completelyRandomConfiguration

        func buttonName() -> String {
            switch self {
            case .simpleExample:
                return "A simple grid example"
            case .defaultGray:
                return "the default gray grid"
            case .randomColorParallelogram:
                return "a random color parallelogram"
            case .whiteBorderlessEdges:
                return "an elegant white grid"
            case .blueExtendedTall:
                return "blue extended tall grid with thick borders"
            case .pinkTriangle:
                return "a pink triangle"
            case .goBoardSquare:
                return "a 13x13 hex Go board"
            case .centerPoints:
                return "dark irregular-sided hexagon grid with center points"
            case .centerPointsAndLines:
                return "green rectangular grid with red lines between cells"
            case .completelyRandomConfiguration:
                return "completely random configuration"
            }
        }
    }

    struct Preset: Hashable {
        let name: String
        let presetType: PresetLoadType
    }

    var presets: [Preset] = loadPresets()
    static func loadPresets() -> [Preset] {
        var presets = [Preset]()
        for type in PresetLoadType.allCases {
            if type == .simpleExample || type == .completelyRandomConfiguration {
                // these are treated as separate options in the SaveMenuView
                continue
            }
            presets.append(Preset(name: type.buttonName(), presetType: type))
        }
        return presets
    }

    var wantsSaveSize: CGSize? = nil
    var wantsSaveAsShare = false
    var wantsSaveAsImage = false
    var wantsPresetLoad: PresetLoadType? = nil

    func config(for type: PresetLoadType) -> HexGridConfig {
        let config = HexGridConfig()
        switch type {
        case .simpleExample:
            // this is not used
            break
        case .defaultGray:
            break
        case .randomColorParallelogram:
            config.gridType = .parallelogram
            config.pointsUp = false
            config.gridSizeX = 15
            config.gridSizeY = 14
            config.initialShading = .random
            config.borderWidth = 3
            config.colorForHexagonBorder = ColorCodable(swiftUIColor: .white)
            config.colorForBackground = ColorCodable(swiftUIColor: .gray)
            config.showsCoordinates = .none
        case .whiteBorderlessEdges:
            config.gridSizeX = 5
            config.gridSizeY = 5
            config.initialShading = .edgesTwoColor
            config.borderWidth = 5
            config.colorForHexagonBorder = ColorCodable(swiftUIColor: .white)
            config.colorForBackground = ColorCodable(swiftUIColor: .white)
            config.showsCoordinates = .none
        case .blueExtendedTall:
            config.gridType = .extendedHexagon
            config.gridSizeX = 5
            config.gridSizeY = 12
            config.pointsUp = false
            config.showsCoordinates = .none
            config.borderWidth = 10
            config.colorForHexagonBorder = ColorCodable(swiftUIColor: Color(red: 47/256, green: 108/256, blue: 140/256))
            config.colorForStateEmpty = ColorCodable(swiftUIColor: Color(red: 210/256, green: 239/256, blue: 253/256))
            config.initialShading = .edgesTwoColor
            config.colorForStateEmptySecondary = ColorCodable(swiftUIColor: Color(red: 61/256, green: 138/256, blue: 176/256))
            config.colorForStateEmptyTertiary = ColorCodable(swiftUIColor: Color(red: 90/256, green: 196/256, blue: 247/256))
            config.colorForBackground = ColorCodable(swiftUIColor: Color(red: 214/256, green: 214/256, blue: 214/256))
        case .pinkTriangle:
            config.gridType = .triangle
            config.gridSizeX = 13
            config.colorForBackground = ColorCodable(swiftUIColor: Color(red: 203/256, green: 240/256, blue: 255/256))
            config.initialShading = .rings
            config.colorForStateEmpty = ColorCodable(swiftUIColor: Color(red: 255/256, green: 181/256, blue: 175/256))
            config.colorForStateEmptySecondary = ColorCodable(swiftUIColor: Color(red: 244/256, green: 164/256, blue: 192/256))
            config.colorForStateEmptyTertiary = ColorCodable(swiftUIColor: Color(red: 255/256, green: 140/256, blue: 130/256))
            config.borderWidth = 2
            config.colorForHexagonBorder = ColorCodable(swiftUIColor: Color(red: 249/256, green: 211/256, blue: 224/256))
        case .goBoardSquare:
            config.gridType = .rectangle
            config.gridSizeX = 13
            config.gridSizeY = 13
            config.pointsUp = false
            config.showsCoordinates = .none
            config.borderWidth = 1
            config.colorForHexagonBorder = ColorCodable(swiftUIColor: .black)
            config.colorForStateEmpty = ColorCodable(swiftUIColor: Color(red: 251/256, green: 232/256, blue: 108/256))
            config.initialShading = .none
            config.interactionTapType = .stone
            config.colorForStateTapped = ColorCodable(swiftUIColor: Color(red: 235/256, green: 235/256, blue: 235/256))
            config.interactionTap2Type = .stone
            config.colorForStateTapped2 = ColorCodable(swiftUIColor: Color(red: 51/256, green: 51/256, blue: 51/256))
            config.interactionDragType = .none
            config.colorForBackground = ColorCodable(swiftUIColor: .white)
        case .centerPoints:
            config.drawCenterPoint = true
            config.drawCenterPointColor = ColorCodable(swiftUIColor: Color(red: 235/256, green: 235/256, blue: 235/256))
            config.drawCenterPointDiameter = 20
            config.gridSizeX = 3
            config.gridSizeY = 4
            config.borderWidth = 0.0
            config.colorForStateEmpty = ColorCodable(swiftUIColor: Color(red: 51/256, green: 51/256, blue: 51/256))
            config.colorForStateEmptySecondary = ColorCodable(swiftUIColor: Color(red: 61/256, green: 61/256, blue: 61/256))
            config.colorForStateEmptyTertiary = ColorCodable(swiftUIColor: Color(red: 71/256, green: 71/256, blue: 71/256))
            config.interactionTap2Type = .color
            config.showsCoordinates = .none
        case .centerPointsAndLines:
            config.drawLinesBetweenCells = true
            config.drawLinesBetweenCellsColor = ColorCodable(swiftUIColor: .red)
            config.drawLinesBetweenCellsWidth = 4.0
            config.drawCenterPoint = true
            config.drawCenterPointColor = ColorCodable(swiftUIColor: .red)
            config.drawCenterPointDiameter = 12
            config.borderWidth = 4.0
            config.colorForHexagonBorder = ColorCodable(swiftUIColor: Color(red: 210/256, green: 231/256, blue: 186/256))
            config.colorForBackground = ColorCodable(swiftUIColor: Color(red: 210/256, green: 231/256, blue: 186/256))
            config.initialShading = .edgesTwoColor
            config.colorForStateEmpty = ColorCodable(swiftUIColor: Color(red: 248/256, green: 250/256, blue: 222/256))
            config.colorForStateEmptySecondary = ColorCodable(swiftUIColor: Color(red: 186/256, green: 220/256, blue: 148/256))
            config.colorForStateEmptyTertiary = ColorCodable(swiftUIColor: Color(red: 226/256, green: 238/256, blue: 214/256))
            config.interactionTap2Type = .color
            config.showsCoordinates = .none
            config.gridType = .rectangle
            config.gridSizeX = 6
            config.gridSizeY = 5
            config.pointsUp = false
            config.offsetEven = false
        case .completelyRandomConfiguration:
            return randomConfiguration()
        }
        return config
    }

    private func randomConfiguration() -> HexGridConfig {
        let config = HexGridConfig()
        config.gridSizeX = Double.random(in: 2..<10)
        config.gridSizeY = Double.random(in: 2..<10)
        if config.gridSizeX > 7 && config.gridSizeY > 7 {
            config.gridSizeX = Double.random(in: 8..<30)
            config.gridSizeY = Double.random(in: 8..<30)
        }
        config.gridType = HexGridConfig.GridType.allCases.randomElement() ?? .irregularHexagon
        while config.gridType == .custom {
            config.gridType = HexGridConfig.GridType.allCases.randomElement() ?? .irregularHexagon
        }
        config.pointsUp = Bool.random()
        config.offsetEven = Bool.random()
        config.showsCoordinates = .none
//        config.showsCoordinates = HexGridConfig.GridCoordinateType.allCases.randomElement() ?? .none
//        config.colorForCoordinateLabels = Color(UIColor.random())
//        config.coordinateLabelFontSize = Double.random(in: 6..<30)
        config.colorForBackground = ColorCodable(swiftUIColor: Color(UIColor.random()))
        config.borderWidth = Double.random(in: 0..<10)
        config.colorForHexagonBorder = ColorCodable(swiftUIColor: Color(UIColor.random()))
        config.drawCenterPoint = Bool.random()
        config.drawCenterPointColor = ColorCodable(swiftUIColor: Color(UIColor.random()))
        config.drawCenterPointDiameter = Double.random(in: 1..<10)
        config.drawLinesBetweenCells = Bool.random()
        config.drawLinesBetweenCellsColor = ColorCodable(swiftUIColor: Color(UIColor.random()))
        config.drawLinesBetweenCellsWidth = Double.random(in: 1..<10)
        config.initialShading = HexGridConfig.GridInitialShading.allCases.randomElement() ?? .rings
        config.colorForStateEmpty = ColorCodable(swiftUIColor: Color(UIColor.random()))
        config.colorForStateEmptySecondary = ColorCodable(swiftUIColor: Color(UIColor.random()))
        config.colorForStateEmptyTertiary = ColorCodable(swiftUIColor: Color(UIColor.random()))
        return config
    }

}

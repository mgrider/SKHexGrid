import SwiftUI
import HexGrid

class ConfigurationData: ObservableObject {

    enum GridCoordinateType: Hashable {
        case none
        case cube
        case offset
        case axial
    }
    enum GridType: Hashable {
        case custom
        case rectangle
//        case hexagon
        case irregularHexagon
        case parallelogram
        case triangle
    }
    enum GridInitialShading: Hashable {
        case none
        case edges
//        case edgesTwoColor
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

struct ConfigurationSheetView: View {

    @StateObject public var gameData = ConfigurationData()

    var doneButtonCallback: ((ConfigurationData) -> Void)?

    var body: some View {

        NavigationView {

            List {

                Section("Grid") {

                    HStack {
                        Picker("View Type", selection: $gameData.gridType, content: {
                            Text("Custom").tag(ConfigurationData.GridType.custom)
                            Text("Hexagon").tag(ConfigurationData.GridType.irregularHexagon)
                            Text("Rectangle").tag(ConfigurationData.GridType.rectangle)
                            Text("Parallelogram").tag(ConfigurationData.GridType.parallelogram)
                            Text("Triangle").tag(ConfigurationData.GridType.triangle)
                        }).pickerStyle(SegmentedPickerStyle())
                    }

                    VStack {
                        HStack {
                            Text("Size x: \(gameData.gridSizeX, specifier: "%.0f")")
                            Spacer()
                        }
                        Slider(value: $gameData.gridSizeX, in: 1...30) {
                            Text("Size: \(gameData.gridSizeX.rounded(), specifier: "%.0f")")
                        }
                        HStack {
                            Text("Size Y: \(gameData.gridSizeY, specifier: "%.0f")")
                            Spacer()
                        }
                        Slider(value: $gameData.gridSizeY, in: 1...30) {
                            Text("Size Y: \(gameData.gridSizeY.rounded(), specifier: "%.0f")")
                        }
                        HStack {
                            Text("Size Y only applies to hexagon, rectangle, and parallelogram grids.").font(.caption)
                            Spacer()
                        }
                    }

                    Toggle(isOn: $gameData.pointsUp, label: {
                        Text("Hexagon points face up")
                    })

                    Toggle(isOn: $gameData.offsetEven, label: {
                        let str: String = gameData.offsetEven ? "Offset is Even" : "Offset is Odd"
                        Text(str)
                    })

                }

                Section("Coordinates") {
                    HStack {
                        Text("Coordinates")
                        Picker("Coordinate Type", selection: $gameData.showsCoordinates, content: {
                            Text("None").tag(ConfigurationData.GridCoordinateType.none)
                            Text("Cube").tag(ConfigurationData.GridCoordinateType.cube)
                            Text("Axial").tag(ConfigurationData.GridCoordinateType.axial)
                            Text("Offset").tag(ConfigurationData.GridCoordinateType.offset)
                        }).pickerStyle(SegmentedPickerStyle())
                    }

                    ColorPicker(
                        "Coordinate Text Color",
                        selection: $gameData.colorForCoordinateLabels,
                        supportsOpacity: false
                    )

                    HStack {
                        Text("Font Size: \(gameData.coordinateLabelFontSize, specifier: "%.0f")")
                        Slider(value: $gameData.coordinateLabelFontSize, in: 6...30) {
                            Text("Font Size: \(gameData.coordinateLabelFontSize.rounded(), specifier: "%.0f")")
                        }
                    }

                }

                Section("Outline / Borders") {

                    ColorPicker(
                        "Border Color",
                        selection: $gameData.colorForHexagonBorder,
                        supportsOpacity: false
                    )

                    HStack {
                        Text("Cell Border width: \(gameData.borderWidth, specifier: "%.0f")")
                        Slider(value: $gameData.borderWidth, in: 0...30) {
                            Text("Border width: \(gameData.borderWidth.rounded(), specifier: "%.0f")")
                        }
                    }
                }

                Section("Cell Colors") {

                    ColorPicker(
                        "Empty Cell Color",
                        selection: $gameData.colorForStateEmpty,
                        supportsOpacity: false
                    )

                    VStack {
                        Text("Initial Shading")
                        HStack {
                            Picker("Coordinate Type", selection: $gameData.initialShading, content: {
                                Text("None").tag(ConfigurationData.GridInitialShading.none)
                                Text("Edges").tag(ConfigurationData.GridInitialShading.edges)
                                Text("Rings").tag(ConfigurationData.GridInitialShading.rings)
                                Text("Three color").tag(ConfigurationData.GridInitialShading.threeColor)
                            }).pickerStyle(SegmentedPickerStyle())
                        }
                        HStack {
                            ColorPicker(
                                "Secondary empty color",
                                selection: $gameData.colorForStateEmptySecondary,
                                supportsOpacity: false
                            )
                            ColorPicker(
                                "Third empty color",
                                selection: $gameData.colorForStateEmptyTertiary,
                                supportsOpacity: false
                            )
                        }
                        HStack {
                            Text("Edges and rings use empty cell color and secondary color.").font(.caption)
                            Spacer()
                        }
                        HStack {
                            Text("(Warning that ring shading can take a bit of time to compute on large grids.)").font(.caption)
                            Spacer()
                        }
                    }
                }

                Section("Interactions") {

                    ColorPicker(
                        "Tap Color",
                        selection: $gameData.colorForStateTapped,
                        supportsOpacity: false
                    )

                    ColorPicker(
                        "Drag Color",
                        selection: $gameData.colorForStateDragContinued,
                        supportsOpacity: false
                    )

                    ColorPicker(
                        "Drag Start Color",
                        selection: $gameData.colorForStateDragBegan,
                        supportsOpacity: false
                    )

                    ColorPicker(
                        "Drag End Color",
                        selection: $gameData.colorForStateDragEnded,
                        supportsOpacity: false
                    )

                }

                Section("Misc") {

                    ColorPicker(
                        "Screen / Background Color",
                        selection: $gameData.colorForBackground,
                        supportsOpacity: false
                    )

                    Toggle(isOn: $gameData.showYellowSecondaryGrid, label: {
                        Text("Show yellow secondary hex2 grid")
                    })

                }

            }.padding()
                .navigationBarTitle(Text("Configuration"), displayMode: .inline)
                .navigationBarItems(
                    trailing: Button(
                        action: {
                            doneButtonCallback?(gameData)
                        }) {
                            Text("Done").bold()
                        }
                )

        } // NavigationView

    }
}

struct ExampleConfigurationSheetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ConfigurationSheetView()
        }
    }
}

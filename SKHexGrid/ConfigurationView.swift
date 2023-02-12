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
        case hexagon
        case parallelogram
        case triangle
    }

    // grid config
    @Published var gridSizeX: Double = 3
    @Published var gridSizeY: Double = 3
    @Published var gridType: GridType = .hexagon
    @Published var pointsUp = true
    @Published var offsetEven = true
    @Published var showsCoordinates: GridCoordinateType = .cube

    // colors
    @Published var colorForBackground: Color = Color(UIColor.systemPink)
    @Published var colorForStateEmpty: Color = Color(UIColor.lightGray)
    @Published var colorForStateTapped: Color = Color(UIColor.systemOrange)
    @Published var colorForStateDragBegan: Color = Color(red: 59/256, green: 172/256, blue: 182/256)
    @Published var colorForStateDragContinued: Color = Color(red: 130/256, green: 219/256, blue: 216/256)
    @Published var colorForStateDragEnded: Color = Color(red: 179/256, green: 232/256, blue: 229/256)

    // misc
    @Published var showYellowSecondaryGrid = true
    @Published var shouldColorEdgesOfTheBoard = false
    @Published var colorForEdgesOfTheBoard: Color = Color(.gray)

    init(
        number: Double = 3,
        gridType: GridType = .hexagon
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
                            Text("Rectangle").tag(ConfigurationData.GridType.rectangle)
                            Text("Hexagon").tag(ConfigurationData.GridType.hexagon)
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
                            Text("(Only applies to rectangle and parallelogram grids.)").font(.caption)
                            Spacer()
                        }
                    }

                    HStack {
                        Text("Coordinates")
                        Picker("Coordinate Type", selection: $gameData.showsCoordinates, content: {
                            Text("None").tag(ConfigurationData.GridCoordinateType.none)
                            Text("Cube").tag(ConfigurationData.GridCoordinateType.cube)
                            Text("Axial").tag(ConfigurationData.GridCoordinateType.axial)
                            Text("Offset").tag(ConfigurationData.GridCoordinateType.offset)
                        }).pickerStyle(SegmentedPickerStyle())
                    }

                    Toggle(isOn: $gameData.pointsUp, label: {
                        Text("Hexagon points face up")
                    })

                    Toggle(isOn: $gameData.offsetEven, label: {
                        let str: String = gameData.offsetEven ? "Offset is Even" : "Offset is Odd"
                        Text(str)
                    })

                }

                Section("Colors") {

                    ColorPicker(
                        "Background Color",
                        selection: $gameData.colorForBackground,
                        supportsOpacity: false
                    )

                    ColorPicker(
                        "Empty Cell Color",
                        selection: $gameData.colorForStateEmpty,
                        supportsOpacity: false
                    )

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

                    Toggle(isOn: $gameData.showYellowSecondaryGrid, label: {
                        Text("Show yellow secondary hex2 grid")
                    })

                    HStack {
                        Toggle(isOn: $gameData.shouldColorEdgesOfTheBoard, label: {
                            Text("Color edges of the board")
                        })
                        ColorPicker(
                            "",
                            selection: $gameData.colorForEdgesOfTheBoard,
                            supportsOpacity: false
                        )
                    }
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

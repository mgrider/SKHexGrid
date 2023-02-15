import SwiftUI
import HexGrid

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
                                Text("Empty").tag(ConfigurationData.GridInitialShading.none)
                                Text("Edges").tag(ConfigurationData.GridInitialShading.edges)
                                Text("Two Edges").tag(ConfigurationData.GridInitialShading.edgesTwoColor)
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

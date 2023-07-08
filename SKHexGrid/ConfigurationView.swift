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
                            Text("Hexagon").tag(ConfigurationData.GridType.irregularHexagon)
                            Text("Extended Hexagon").tag(ConfigurationData.GridType.extendedHexagon)
                            Text("Rectangle").tag(ConfigurationData.GridType.rectangle)
                            Text("Parallelogram").tag(ConfigurationData.GridType.parallelogram)
                            Text("Triangle").tag(ConfigurationData.GridType.triangle)
                            Text("Custom").tag(ConfigurationData.GridType.custom)
                        })//.pickerStyle(SegmentedPickerStyle())
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

                }

                Section("Coordinates") {
                    HStack {
                        Picker("Coordinate Display", selection: $gameData.showsCoordinates, content: {
                            Text("None").tag(ConfigurationData.GridCoordinateType.none)
                            Text("Cube").tag(ConfigurationData.GridCoordinateType.cube)
                            Text("Axial").tag(ConfigurationData.GridCoordinateType.axial)
                            Text("Offset").tag(ConfigurationData.GridCoordinateType.offset)
                        })//.pickerStyle(SegmentedPickerStyle())
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

                    Toggle(isOn: $gameData.offsetEven, label: {
                        let str: String = gameData.offsetEven ? "Offset: Even" : "Offset: Odd"
                        Text(str)
                    })

                }

                Section("Outline / Borders") {

                    ColorPicker(
                        "Border color",
                        selection: $gameData.colorForHexagonBorder,
                        supportsOpacity: false
                    )

                    HStack {
                        Text("Cell border width: \(gameData.borderWidth, specifier: "%.0f")")
                        Slider(value: $gameData.borderWidth, in: 0...30) {
                            Text("Border width: \(gameData.borderWidth.rounded(), specifier: "%.0f")")
                        }
                    }
                }

                Section("Center Points") {

                    Toggle(isOn: $gameData.drawCenterPoint, label:{
                        Text("Draw center point")
                    })

                    ColorPicker(
                        "Center point color",
                        selection: $gameData.drawCenterPointColor,
                        supportsOpacity: true
                    )

                    HStack {
                        Text("Center point diameter: \(gameData.drawCenterPointDiameter, specifier: "%.0f")")
                        Slider(value: $gameData.drawCenterPointDiameter, in: 0...100) {
                            Text("Center point diameter: \(gameData.drawCenterPointDiameter, specifier: "%.0f")")
                        }
                    }
                }

                Section("Lines between cells") {

                    Toggle(isOn: $gameData.drawLinesBetweenCells, label:{
                        Text("Draw lines between cells")
                    })

                    ColorPicker(
                        "Color for lines between cells",
                        selection: $gameData.drawLinesBetweenCellsColor,
                        supportsOpacity: true
                    )

                    HStack {
                        Text("Line width: \(gameData.drawLinesBetweenCellsWidth, specifier: "%.0f")")
                        Slider(value: $gameData.drawLinesBetweenCellsWidth, in: 0...100) {
                            Text("Line width: \(gameData.drawLinesBetweenCellsWidth, specifier: "%.0f")")
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
                        HStack {
                            Text("Initial (Empty Cell) Shading")
                            Spacer()
                        }
                        Picker("Shading Type", selection: $gameData.initialShading, content: {
                            Text("Empty").tag(ConfigurationData.GridInitialShading.none)
                            Text("Edges").tag(ConfigurationData.GridInitialShading.edges)
                            Text("Two-color Edges").tag(ConfigurationData.GridInitialShading.edgesTwoColor)
                            Text("Rings").tag(ConfigurationData.GridInitialShading.rings)
                            Text("Three-color Rings").tag(ConfigurationData.GridInitialShading.ringsThreeColor)
                            Text("Random").tag(ConfigurationData.GridInitialShading.random)
                            Text("Three color").tag(ConfigurationData.GridInitialShading.threeColor)
                        })//.pickerStyle(SegmentedPickerStyle())
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

                    // MARK: tap 1

                    Picker("Tap Effect", selection: $gameData.interactionTapType, content: {
                        Text("None").tag(ConfigurationData.GridCellTapInteractionType.none)
                        Text("Color Change").tag(ConfigurationData.GridCellTapInteractionType.colorChange)
                        Text("Add Stone").tag(ConfigurationData.GridCellTapInteractionType.shapeAddStone)
                    })
                    ColorPicker(
                        "Tap Effect Color",
                        selection: $gameData.colorForStateTapped,
                        supportsOpacity: false
                    )

                    // MARK: tap 2

                    Picker("Second Tap Effect", selection: $gameData.interactionTap2Type, content: {
                        Text("None").tag(ConfigurationData.GridCellTapInteractionType.none)
                        Text("Color Change").tag(ConfigurationData.GridCellTapInteractionType.colorChange)
                        Text("Add Stone").tag(ConfigurationData.GridCellTapInteractionType.shapeAddStone)
                    })
                    ColorPicker(
                        "Second Tap Effect Color",
                        selection: $gameData.colorForStateTapped2,
                        supportsOpacity: false
                    )

                    // MARK: drag

                    Picker("Drag Effect", selection: $gameData.interactionDragType, content: {
                        Text("None").tag(ConfigurationData.GridCellDragInteractionType.none)
                        Text("Color Change").tag(ConfigurationData.GridCellDragInteractionType.colorChange)
                        Text("Move Existing").tag(ConfigurationData.GridCellDragInteractionType.dragExistingState)
                    })

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

                    // MARK: pinch/zoom

                    Toggle(isOn: $gameData.isInteractionPinchZoomAllowed, label: {
                        Text("Pinch to change zoom-level of the grid")
                    })

                    Toggle(isOn: $gameData.isInteractionTwoFingerDragGridAllowed, label: {
                        Text("Two-finger drag to move the grid")
                    })

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

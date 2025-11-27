import SwiftUI
import HexGrid

struct ConfigurationSheetView: View {

    @State public var gameData = ConfigurationData()

    var doneButtonCallback: ((ConfigurationData) -> Void)?

    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter
    }()

    var body: some View {

        NavigationView {

            List {

                Section("Generated grid") {

                    VStack {
                        Picker("Grid type", selection: $gameData.gridType, content: {
                            Text("Hexagon").tag(ConfigurationData.GridType.irregularHexagon)
                            Text("Extended hexagon").tag(ConfigurationData.GridType.extendedHexagon)
                            Text("Rectangle").tag(ConfigurationData.GridType.rectangle)
                            Text("Parallelogram").tag(ConfigurationData.GridType.parallelogram)
                            Text("Triangle").tag(ConfigurationData.GridType.triangle)
                            Text("Custom").tag(ConfigurationData.GridType.custom)
                        })//.pickerStyle(SegmentedPickerStyle())
                        HStack {
                            switch gameData.gridType {
                            case .irregularHexagon:
                                Text("A standard hexagonal grid. When X and Y values are different, this is actually using the \"Irregular\" HexGrid generator type, and every other side will have lengths of X or Y values.").font(.caption)
                            case .extendedHexagon:
                                Text("A grid type where two of the parallel sides are X or Y length, where hexagon points face up or not, respectively.").font(.caption)
                            case .custom:
                                Text("This is the only grid type that doesn't use a HexGrid generator. You can configure the cells below.").font(.caption)
                            case .rectangle:
                                Text("The Rectangle grid type makes a roughly rectangular (or square) grid shape with sides of X and Y length.").font(.caption)
                            case .parallelogram:
                                Text("A parallelogram grid shape with side lengths of X and Y.").font(.caption)
                            case .triangle:
                                Text("The triangle grid type has equal sides of X length.").font(.caption)
                            }
                            Spacer()
                        }
                    }

                    VStack {
                        switch gameData.gridType {
                        case .irregularHexagon, .extendedHexagon, .rectangle, .parallelogram:
                            HStack {
                                Text("Size x: \(gameData.gridSizeX, specifier: "%.0f")")
                                Slider(value: $gameData.gridSizeX, in: 1...30) {
                                    Text("Size: \(gameData.gridSizeX.rounded(), specifier: "%.0f")")
                                }
                            }
                            HStack {
                                Text("Size Y: \(gameData.gridSizeY, specifier: "%.0f")")
                                Slider(value: $gameData.gridSizeY, in: 1...30) {
                                    Text("Size Y: \(gameData.gridSizeY.rounded(), specifier: "%.0f")")
                                }
                            }
                        case .custom:
                            NavigationLink("Configure custom cells") {
                                List {
                                    Section {
                                        HStack {
                                            Text("Cell coordinates").font(.title2)
                                            Spacer()
                                            Button("Add cell", action: {
                                                gameData.customCells.append(.init(coordinateQ: 0, coordinateR: 0))
                                            }).buttonStyle(.bordered)
                                        }
                                        HStack {
                                            Text(
"""
Edit the Axial coordinates below.

Newly added coordinates will appear at the bottom of the list.
""").font(.caption)
                                            Spacer()
                                        }
                                    }
                                    Section {
                                        ForEach($gameData.customCells) { $cell in
                                            HStack {
                                                TextField("axial q", value: $cell.coordinateQ, formatter: numberFormatter)
                                                TextField("axial r", value: $cell.coordinateR, formatter: numberFormatter)
                                            }
                                        }
                                    }
                                }
                            }

                        case .triangle:
                            HStack {
                                Text("Size x: \(gameData.gridSizeX, specifier: "%.0f")")
                                Slider(value: $gameData.gridSizeX, in: 1...30) {
                                    Text("Size: \(gameData.gridSizeX.rounded(), specifier: "%.0f")")
                                }
                            }
                        }
                    }

                    Toggle(isOn: $gameData.pointsUp, label: {
                        Text("Hexagon points face up")
                    })

                }

                Section("Cell coordinates") {
                    HStack {
                        Picker("Coordinate display", selection: $gameData.showsCoordinates, content: {
                            Text("None").tag(ConfigurationData.GridCoordinateType.none)
                            Text("Cube").tag(ConfigurationData.GridCoordinateType.cube)
                            Text("Axial").tag(ConfigurationData.GridCoordinateType.axial)
                            Text("Offset").tag(ConfigurationData.GridCoordinateType.offset)
                            Text("Alphanumeric").tag(ConfigurationData.GridCoordinateType.alphanumeric)
                        })//.pickerStyle(SegmentedPickerStyle())
                    }

                    ColorPicker(
                        "Coordinate text color",
                        selection: $gameData.colorForCoordinateLabels,
                        supportsOpacity: false
                    )

                    HStack {
                        Text("Font size: \(gameData.coordinateLabelFontSize, specifier: "%.0f")")
                        Slider(value: $gameData.coordinateLabelFontSize, in: 6...30) {
                            Text("Font size: \(gameData.coordinateLabelFontSize.rounded(), specifier: "%.0f")")
                        }
                    }

                    Toggle(isOn: $gameData.offsetEven, label: {
                        let str: String = gameData.offsetEven ? "Offset: Even" : "Offset: Odd"
                        Text(str)
                    })

                    VStack {
                        Toggle(isOn: $gameData.usePositiveCoordinateValuesOnly, label: {
                            Text("Use positive coordinate values")
                        })
                        HStack {
                            Text("This requires coordinate remapping after grid generation. The \"Alphanumeric\" coordinate display type does this by default.").font(.caption)
                            Spacer()
                        }
                    }

                }

                Section("Outlines and borders") {

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

                Section("Center points") {

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

                    HStack {
                        Text("Note that center points will be drawn underneath coordinates, but they are both drawn in the middle of the cell, so should be considered together.").font(.caption)
                        Spacer()
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

                Section("Cell colors") {

                    Picker("Cell shading type", selection: $gameData.initialShading, content: {
                        Text("Single color").tag(ConfigurationData.GridInitialShading.none)
                        Text("Edges").tag(ConfigurationData.GridInitialShading.edges)
                        Text("Two-color Edges").tag(ConfigurationData.GridInitialShading.edgesTwoColor)
                        Text("Rings").tag(ConfigurationData.GridInitialShading.rings)
                        Text("Three-color Rings").tag(ConfigurationData.GridInitialShading.ringsThreeColor)
                        Text("Random").tag(ConfigurationData.GridInitialShading.random)
                        Text("Three color").tag(ConfigurationData.GridInitialShading.threeColor)
                        Text("Periodic second color").tag(ConfigurationData.GridInitialShading.periodic1)
                        Text("More periodic second color").tag(ConfigurationData.GridInitialShading.periodic2)
                    })//.pickerStyle(SegmentedPickerStyle())

                    ColorPicker(
                        "Default (first) cell shading color",
                        selection: $gameData.colorForStateEmpty,
                        supportsOpacity: false
                    )

                    ColorPicker(
                        "Secondary cell shading color",
                        selection: $gameData.colorForStateEmptySecondary,
                        supportsOpacity: false
                    )

                    ColorPicker(
                        "Third cell shading color",
                        selection: $gameData.colorForStateEmptyTertiary,
                        supportsOpacity: false
                    )

                    Text("""
The third cell shading color is only used for Two-color-edges and Three-color-ring styles.

Random shading will be different every time the grid is generated. (Which means every time this menu's Done button is pressed.)

Warning that ring shading can take a bit of time to compute on larger grid sizes.
""").font(.caption)

                }

                Section("Background") {

                    ColorPicker(
                        "Screen / window background color",
                        selection: $gameData.colorForBackground,
                        supportsOpacity: false
                    )
                }

                Section("Interactions") {

                    // MARK: tap 1

                    Picker("Tap effect", selection: $gameData.interactionTapType, content: {
                        Text("None").tag(ConfigurationData.GridCellTapInteractionType.none)
                        Text("Color change").tag(ConfigurationData.GridCellTapInteractionType.colorChange)
                        Text("Add stone").tag(ConfigurationData.GridCellTapInteractionType.shapeAddStone)
                    })
                    ColorPicker(
                        "Tap effect color",
                        selection: $gameData.colorForStateTapped,
                        supportsOpacity: false
                    )

                    // MARK: tap 2

                    Picker("Second tap effect", selection: $gameData.interactionTap2Type, content: {
                        Text("None").tag(ConfigurationData.GridCellTapInteractionType.none)
                        Text("Color change").tag(ConfigurationData.GridCellTapInteractionType.colorChange)
                        Text("Add stone").tag(ConfigurationData.GridCellTapInteractionType.shapeAddStone)
                    })
                    ColorPicker(
                        "Second tap effect color",
                        selection: $gameData.colorForStateTapped2,
                        supportsOpacity: false
                    )

                    // MARK: drag

                    Picker("Drag effect", selection: $gameData.interactionDragType, content: {
                        Text("None").tag(ConfigurationData.GridCellDragInteractionType.none)
                        Text("Color change").tag(ConfigurationData.GridCellDragInteractionType.colorChange)
                        Text("Move existing tap effect").tag(ConfigurationData.GridCellDragInteractionType.dragExistingState)
                    })

                    ColorPicker(
                        "Drag color",
                        selection: $gameData.colorForStateDragContinued,
                        supportsOpacity: false
                    )

                    ColorPicker(
                        "Drag start color",
                        selection: $gameData.colorForStateDragBegan,
                        supportsOpacity: false
                    )

                    ColorPicker(
                        "Drag end color",
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

                    Toggle(isOn: $gameData.showYellowSecondaryGrid, label: {
                        Text("Show yellow secondary grid")
                    })

                    Text("""
This really has no purpose other than to show how you can have an arbitrary number of grids shown on the screen at once.
""").font(.caption)

                }

            }
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

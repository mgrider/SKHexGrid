import SwiftUI
import HexGrid

struct ConfigurationSheetView: View {

    @StateObject public var gameData = ConfigurationData()

    var doneButtonCallback: ((ConfigurationData) -> Void)?

    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter
    }()

    var body: some View {

        NavigationView {

            List {

                Section("Generated grid") {

                    HStack {
                        Picker("Grid type", selection: $gameData.gridType, content: {
                            Text("Hexagon").tag(ConfigurationData.GridType.irregularHexagon)
                            Text("Extended hexagon").tag(ConfigurationData.GridType.extendedHexagon)
                            Text("Rectangle").tag(ConfigurationData.GridType.rectangle)
                            Text("Parallelogram").tag(ConfigurationData.GridType.parallelogram)
                            Text("Triangle").tag(ConfigurationData.GridType.triangle)
                            Text("Custom").tag(ConfigurationData.GridType.custom)
                        })//.pickerStyle(SegmentedPickerStyle())
                    }

                    VStack {
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
                        HStack {
                            Text("Size Y only applies to hexagon, rectangle, and parallelogram grids.").font(.caption)
                            Spacer()
                        }
                    }

                    Toggle(isOn: $gameData.pointsUp, label: {
                        Text("Hexagon points face up")
                    })

                    NavigationLink("Configure custom cells") {
                        List(gameData.customCells) { cell in
                            HStack {
//                                TextField("q: ", value: cell.coordinateQ, formatter: numberFormatter)
//                                TextField("r: ", value: cell.coordinateR, formatter: numberFormatter)
                            }
                        }
                    }

                }

                Section("Cell coordinates") {
                    HStack {
                        Picker("Coordinate display", selection: $gameData.showsCoordinates, content: {
                            Text("None").tag(ConfigurationData.GridCoordinateType.none)
                            Text("Cube").tag(ConfigurationData.GridCoordinateType.cube)
                            Text("Axial").tag(ConfigurationData.GridCoordinateType.axial)
                            Text("Offset").tag(ConfigurationData.GridCoordinateType.offset)
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
Edges and rings use default and secondary colors. The third color is only used for Two-color-edges and Three-color-ring styles. Random shading will be different every time the grid is generated. (Which means every time this menu is opened.)

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

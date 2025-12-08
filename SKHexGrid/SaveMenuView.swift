import SwiftUI

struct SaveMenuView: View {

    @State public var gameData = SaveMenuViewData()

    var doneButtonCallback: ((SaveMenuViewData) -> Void)?

    let imageSizes: [CGFloat] = [600, 1024, 1080, 2048, 3840]

    var body: some View {

        NavigationView {

            List {

                Section("Load grid configuration") {

                    HStack {
                        Menu("Pick a preset...") {
                            ForEach(gameData.presets, id: \.presetType) { preset in
                                Button(preset.name) {
                                    gameData.wantsPresetLoad = preset.presetType
                                    doneButtonCallback?(gameData)
                                }
                            }
                        }
                        Spacer()
                    }

                    HStack {
                        Button("Configure a random grid") {
                            gameData.wantsPresetLoad = .completelyRandomConfiguration
                            doneButtonCallback?(gameData)
                        }.buttonStyle(.borderless)
                        Spacer()
                    }

                    Text("WARNING: These options will reset the currently configured grid.").font(.caption)

                }

                Section("Load simple grid example") {

                    HStack {
                        Button("Load simple grid example") {
                            gameData.wantsPresetLoad = .simpleExample
                            doneButtonCallback?(gameData)
                        }.buttonStyle(.borderless)
                        Spacer()
                    }

                    Text("This example is not configurable.").font(.caption)

                }

                Section("Save or share a photo") {

                    HStack {
                        Menu("Save image to photo library...") {
                            ForEach(0..<imageSizes.count, id: \.self) { value in
                                Button("\(Int(imageSizes[value])) x \(Int(imageSizes[value]))") {
                                    gameData.wantsSaveAsImage = true
                                    gameData.wantsSaveSize = .init(width: imageSizes[value], height: imageSizes[value])
                                    doneButtonCallback?(gameData)
                                }
                            }
                        }
                        Spacer()
                    }

                    HStack {
                        Menu("Share an image...") {
                            ForEach(0..<imageSizes.count, id: \.self) { value in
                                Button("\(Int(imageSizes[value])) x \(Int(imageSizes[value]))") {
                                    gameData.wantsSaveAsShare = true
                                    gameData.wantsSaveSize = .init(width: imageSizes[value], height: imageSizes[value])
                                    doneButtonCallback?(gameData)
                                }
                            }
                        }
                        Spacer()
                    }
                    Text("""
This will create an image of the currently configured grid to save to your photo library or share with the system share sheet.
""").font(.caption)

                }

            }
                .navigationBarTitle(Text("Save Menu"), displayMode: .inline)
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

//struct ExampleConfigurationSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ConfigurationSheetView()
//        }
//    }
//}


import SwiftUI

struct AboutView: View {

    var doneButtonCallback: (() -> Void)?

    var versionString: String = {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.x"
    }()

    var body: some View {

        NavigationView {

            ScrollView {

                Text("What is SKHexGrid?").font(.title)

                Text("""

SKHexGrid is an [open source](https://github.com/mgrider/skhexgrid) project, showing how to use Apple's SpriteKit and another open source library called [HexGrid](https://github.com/fananek/hex-grid) to draw hexagonal grids in various configurations.


""")

                Text("What can I do with it?").font(.title)

                Text("""

\(Image(systemName: "square.and.arrow.down")) save / load menu

Press the \(Image(systemName: "square.and.arrow.down")) button to load a preset grids, or to save the current grid to your photos library. Looking at the presets is a great way to see some of the things that are possible with this application.

\(Image(systemName: "gear")) configuration menu

Pressing the \(Image(systemName: "gear")) button will let you see (and change!) the current grid's configuration. There are lots of options in here. Feel free to play around with them!

\(Image(systemName: "questionmark.app")) other uses

There are a couple of other uses imagined for this application (outside of serving as a nice example for the `HexGrid` library):

1. You can **configure** and then **Save** images of hexagonal grids for use elsewhere. (For example, you might configure a grid for a [board game played on a hexagonal grid](https://boardgamegeek.com/boardgamemechanic/2026/hexagon-grid), save it, then find it in your photos library and print it from there.)

2. You could also use a grid to play some basic games pass-and-play right here inside the app. There are many games on Board Game Geek playable on a hex grid without much necessary equipment. Here are links to a couple of lists:

    • [games played on a hexagonal grid (of any size), with single color markers/pieces/tokens](https://boardgamegeek.com/geeklist/228019/single-color-hexagons)
    • [hexagonal territorial games with placement/capture but no movement](https://boardgamegeek.com/boardgamemechanic/2026/hexagon-grid)

""")

                Text("Who made this?").font(.title)

                Text("""

`SKHexGrid` was made by Martin Grider. You can find more apps and games by Martin at his website, [http://abstractpuzzle.com](http://abstractpuzzle.com).

The `HexGrid` project was originally created by [František Mikš](https://github.com/fananek) and [Paul McKeown](https://github.com/pmckeown).

HexGrid was heavily influenced by (and in many cases based on) the work of Amit Patel, whose [tutorial on hexagonal grids](https://www.redblobgames.com/grids/hexagons/) has inspired and helped countless game developers for many years.

""")

            }.padding()
                .navigationBarTitle(Text("About this app - v.\(versionString)"), displayMode: .inline)
                .navigationBarItems(
                    trailing: Button(
                        action: {
                            doneButtonCallback?()
                        }) {
                            Text("Done").bold()
                        }
                )

        } // NavigationView

    }
}

struct ExampleAboutView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AboutView()
        }
    }
}

# SKHexGrid

An example project using [SpriteKit](https://developer.apple.com/spritekit/) and [HexGrid](https://github.com/fananek/hex-grid) to draw hexagonal grids in various configurations.

This project contains (at present) two distinct examples.

1. The simplest possible SpriteKit Scene that initializes and renders the cells of a HexGrid. See this example by running the project and selecting "Load simple grid example" in the Load/Save menu. See the code for that example in [`SimpleHexGridScene.swift`](SKHexGrid/SimpleHexGridScene.swift).

2. The second example is a highly-configurable and rather complex scene that shows off the power of all the built-in hex-grid generator functions. Use the configuration menu in the upper-right corner of the screen to customize the look and behavior of the grid, including display of the various types of coordinate systems built into the library.


## How to use this project

### Get it running

You can either get the app from the iOS App Store, or build it yourself with Xcode.

#### From the App Store

This project has been published in the iOS App Store, where it is called [Hexagon Grid Generator](https://apps.apple.com/us/app/hexagon-grid-generator/id6445898427). If you just want to use the project, and don't care about modifying or seeing the source code, then that's your best bet. You'll need a device with iOS, iPadOS, or macOS. It's a free download.

#### Build it yourself from source

1. First off, you'll need a version of Xcode
2. Download this repository
3. Open the `SKHexGrid.project` file with Xcode
4. Build and run the project
    - You may need to pick a deployment target first.

### Load various preset examples

Use the save/load button (the middle button) to find a list of preset examples you can view. Once you've loaded a preset, you can feel free to play with its properties using the configuration button.

### Configure the grid

Use the configuration button (gear icon in upper-right) to switch between different types of grid layouts, color schemes, coordinate display types, allowed interactions and state changes, and much more.

### Save an image of the grid

Back in the save/load menu, you can also save an image of the current grid to your photo library. 


## History / Release Notes

### v0.6.0

* renamed various configuration entity and property names
* added a drag-to-copy-state option

### v0.5.0

* added the ability to share an image of the current grid using the system share sheet
* added a sub-menu for size of image to save or share in the save menu
* modernized image saving code somewhat
* switched from @Published macros everywhere to @Observable macros
* separated HexGridConfiguration from ConfigurationViewData

### v0.4.4

* added periodic cell shading (with distance between shaded cells 1 and 2)
* added a configuration boolean for shifting to positive axial coordinates
* new alphanumeric coordinate type shows coordinates as letter-number combinations
* added the ability to customize the array of grid cells and add/edit their coordinates
* added more help text for each grid type, and dynamically removed the Y coordinate for Triangular grids

### v0.4.3

* added reference to the App Store to this README
* moved center point drawing to happen before (thus underneath) coordinate labels
* configuration UI (ConfigurationView) changes:
  * no longer references "empty" cells
  * moved screen background color above the interaction section
  * added various help text blocks at the bottom of some sections (could use more)
  * more consistency of capitalization throughout
* fixed one of the geeklist links on the About screen
* commented out the "Custom" grid type (until I get around to implementing custom cells as an array)
* added random configuration button
* overhauled the SaveMenuView: moved the presets into a Menu

### v0.4.2

* fixed layout issues when running on macOS
* Add option to draw lines between the center points of adjacent cells
* added a new preset for lines between cells, minor changes to some existing presets
* updated the "about this app" contents a bit

### v0.4.1

* added the option to draw dots in the center of each cell
* added center point grid example
* added version string in the about screen's navigation title

### v0.4.0

* allow pinch/zoom gesture and 2-finger drag to translate the hexagon grid
* allow drag gesture to move the existing cell's interaction state
* moved the drag-handling code into a helper class (`HexGridSceneDragCoordinator`)
* added the ability for tap gestures to add "stone like" shapes to the board
* added button to reset view after pinch/zooming

### v0.3.3

* added support for `extendedHexagon` generator type
* added more shading options:
  - 2-color edges
  - three-color rings
* Remember the background color for each cell so tapping/dragging doesn't mess up the initial colors
* Added a second tap state, so you can toggle between three colors empty->tap1->tap2->empty->etc...
* Added a type for tap and tap2, so these can be customized further in the future
* Added a type for drag interaction (turned off by default)
* added an about screen, with links to github, abstractpuzzle.com, and redblobgames original tutorial
* added an app icon

### v0.3.2

* revamped README & instructions
* added a few more preset grid types (and made it easier to add more)
* fixed a bug with large borders getting cut off
* fixed menu pickers with lots of options getting truncated

### v0.3.1

* added the save/load menu
* made it possible to save an image of the view to the photos library
* made it possible to load the default grid again from the save menu
* added `SimpleHexGridScene.swift`, and button to load it from the save/load menu
* added option for random initial colors

### v0.3.0

* new grid options for Irregular Hexagons & Parallelograms
* made most colors customizable
* added customization of coordinate label color and font size
* added initial shading options, edges, 2-color edges, rings, and tri-color
* tweaked defaults to not show the secondary overlay grid, picked new colors & shading
* added an option to change the size of (or remove) the border between cells

### v0.2.0

Roughly corresponds to HexGrid version 0.4.10.

* draws coordinates on top of each grid cell (type is based on the configuration)
* fixed iPadOS & macOS targets which were crashing when opening the config menu
* moved from using `isHighlighted` to using a state `Int` instead, with some state colors defined in `Cell+State.swift`
* moved from touch delegate methods to gesture-based input in `HexGridScene`

### v0.1.0

* draws a grid based on a configurable state object, including square, hex, and triangle examples


## Backlog / ideas list

* Make it clearer which configuration options are from `HexGrid` and which are unique to this project.
  - write clear explanations for each configuration option in the code
* Make additional things configurable
  - the frame of the hexagon? (or just inset/padding, maybe?)
* interaction ideas
  - Add an option to add shapes on cell tap
    - options might include: square, circle, triangle
  - add long-press gesture and associated action type enum
  - make tap-types into an array of arbitrary length
  - add rotate gesture
  - add menu with buttons for zoom/scroll/rotate/reset (macOS version needs this especially)
* add concept of "cell highlight"
  - a type enum might include: border change (color and/or width), color change, some kind of overlay (maybe?)
  - add `highlightCells` case to drag type enum, tap type enums
  - add tap type options to highlight various cells relative to the tapped cell:
    - neighboring cells
    - diagonally neighboring cells
    - path(s) to other tapped cells(?)
    - (The idea here would be to expose more of the HexGrid API in the demo, so look at API for ideas.)
  - whenever highlighting any cells, remove previously highlighted cells first
* Add more visual effects
  - animate the border of a tapped cell
  - screen shake
  - growing and shrinking of cells
* additional "canned" examples
  - An example drawn with `UIKit`
  - A fully functioning game example? ([Hex](https://en.wikipedia.org/wiki/Hex_(board_game)) maybe?)
* additional coordinate ideas
  - allow shifting of all grid coordinates (there is a start for this in the `shifting-coordinates` branch)
    - 1 direction at a time
    - moving offset coordinate 0,0 all the way to an edge of the grid
  - toggle drawing an extra cell in 2 or 3 directions, and only drawing coordinates (for the relevant axis) in that cell
* Allow the user to save their hex grid (including any current states)
* Allow the user to export the current grid as PDF, specifying the size of each cell
* Add option to choose a woodgrain background
* Add the possibility for arbitrary text annotations
* Allow for coloring the edges of the board
* Ideas & issues that involve grids that scroll off the edge of the screen (without using the transform)
  - fix resolution "blurriness" when zooming in on large grids
  - An example that does not "fit" to the screen size, and instead is much larger and scrolls off-screen in all directions
  - An option that "tiles" the configured grid (only some configurations will tile perfectly)
  - Allow toggling between "fitting the grid on the screen" and "select a radius for each cell"
    - see ["drawing the grid"](https://github.com/fananek/hex-grid#drawing-the-grid) in the hex-grid README
  - one idea for this has been started on the `anchor-position` branch

### Some ideas more suitable for the main hex-grid project

* remove `Cell` `isOpaque` and `isBlocked` properties in favor of attributes with the same names
  - write optional "where" clauses for all the functions that use them instead. (This would allow the API to return all cells neighboring a cell _where_ an attribute is true, or to find a path of cells sharing an attribute, similar.)
* move each of the shading-type algorithms to functions on `hex-grid`

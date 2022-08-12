# SKHexGrid

An example project using [SpriteKit](https://developer.apple.com/spritekit/) and [HexGrid](https://github.com/fananek/hex-grid) to draw hexagonal grids in various configurations.


## How to use this project

1. Download this project
2. Open the project in Xcode
3. Pick a deployment target (any iOS simulator should work)
4. Run the project
5. Use the configuration button (gear icon in upper-right) to switch between different types of grid layout


## History / Release Notes

### v0.2.0

Roughly corresponds to HexGrid version 0.4.10.

* draws coordinates on top of each grid cell (type is based on the configuration)
* fixed iPadOS & macOS targets which were crashing when opening the config menu
* moved from using `isHighlighted` to using a state `Int` instead, with some state colors defined in `Cell+State.swift`
* moved from touch delegate methods to gesture-based input in `HexGridScene`

### v0.1.0

* draws a grid based on a configurable state object, including square, hex, and triangle examples


## Backlog / ideas list

* Make additional things configurable
  - state colors & scene background colors
  - the coordinates for "custom" generation
  - the frame of the hexagon(s)
  - allow toggling on/off the secondary hexagon (currently a yellow background)
    - or _maybe_ make an array of configuration objects, and allow any number of hexagons to be drawn
* Allow drawing a border around the edges of the grid
  - maybe margin values & colors for each `Direction`
* Add more visual effects
  - animate the border of a tapped cell
  - screen shake
  - growing and shrinking of cells
* Add the concept of a "current cell", and buttons to highlight various cells relative to that cell. (The idea here would be to expose more of the HexGrid API in the demo.)
  - neighboring cells
  - diagonally neighboring cells
  - shortest path to some other cell
* Add a UINavigationController and additional types of examples.
  - An example drawn with `UIKit`
  - An example that does not "fit" to the screen size, and instead is much larger and scrolls off screen in all directions
  - A fully functioning game example? ([Hex](https://en.wikipedia.org/wiki/Hex_(board_game)) maybe?)
* allow shifting of all grid coordinates (this has been started in the shifting-coordinates branch)
  - 1 direction at a time
  - moving offset coordinate 0,0 all the way to an edge of the grid

### Some ideas more suitable for the main hex-grid project

* remove `Cell` `isOpaque` and `isBlocked` properties in favor of attributes with the same names
  - write optional "where" clauses for all the functions that use them instead. (This would allow the API to return all cells neighboring a cell _where_ an attribute is true, or to find a path of cells sharing an attribute, similar.)

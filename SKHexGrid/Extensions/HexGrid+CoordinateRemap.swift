import Foundation
import HexGrid

extension HexGrid {

    func setCellCoordinatesToPositiveValues() {
        var minimumAxialQ: Int = .max
        var minimumAxialR: Int = .max
        for cell in cells {
            let axial = cell.coordinates.toAxial()
            if axial.q < minimumAxialQ { minimumAxialQ = axial.q }
            if axial.r < minimumAxialR { minimumAxialR = axial.r }
        }
        let toAdd = (minimumAxialQ <= minimumAxialR) ? abs(minimumAxialQ) : abs(minimumAxialR)
        var newCells = Set<Cell>()
        for cell in cells {
            let axial = cell.coordinates.toAxial()
            let newAxial = AxialCoordinates(q: axial.q+toAdd, r: axial.r+toAdd)
            if let newCube = try? newAxial.toCube() {
                newCells.insert(Cell(newCube))
            }
        }
        cells = newCells
    }
}

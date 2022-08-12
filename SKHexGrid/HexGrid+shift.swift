import HexGrid

extension HexGrid {

    public func shiftXYToPositive() throws {
        var newCells = Set<Cell>()
        var currentOffset: OffsetCoordinates
        var minX: Int = .max
        var minY: Int = .max
        for cell in cells {
            currentOffset = cell.coordinates.toOffset(orientation: orientation, offsetLayout: offsetLayout)
            minX = min(minX, currentOffset.column)
            minY = min(minY, currentOffset.row)
        }
        if minX != 0 || minY != 0 {
            var newOffset: OffsetCoordinates
            for cell in cells {
                currentOffset = cell.coordinates.toOffset(orientation: orientation, offsetLayout: offsetLayout)
                newOffset = OffsetCoordinates(
                    column: currentOffset.column-minX,
                    row: currentOffset.row-minY,
                    orientation: orientation,
                    offsetLayout: offsetLayout)
                newCells.insert(try Cell(newOffset.toCube()))
            }
        }
        self.cells = newCells
    }

    public func addCoordinatesToCells(coordinateToAdd: CubeCoordinates) throws {
        var newCells = Set<Cell>()
        for cell in cells {
            newCells.insert(try Cell(CubeCoordinates(
                x: cell.coordinates.x+coordinateToAdd.x,
                y: cell.coordinates.y+coordinateToAdd.y,
                z: cell.coordinates.z+coordinateToAdd.z
            )))
        }
        self.cells = newCells
    }
}

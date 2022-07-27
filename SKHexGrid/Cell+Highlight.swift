import HexGrid

extension Cell {
    var isHighlighted : Bool {
        return (self.attributes["isHighlighted"] == true)
    }
    
    func toggleHighlight() {
        if !self.isBlocked {
            if self.attributes["isHighlighted"] == true {
                self.attributes["isHighlighted"] = false
            } else {
                self.attributes["isHighlighted"] = true
            }
        }
    }
}

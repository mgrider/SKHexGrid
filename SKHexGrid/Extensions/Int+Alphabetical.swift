import Foundation

extension Int {

    /// the letters in the alphabet. There may be a better way to get these.
    public static let alphabet = [
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
        "k", "l", "m", "n", "o", "p", "q", "r", "s", "t",
        "u", "v", "w", "x", "y", "z",
    ]

    /// Returns an alphabetical representation of this Integer.
    ///
    /// Note that this is zero-indexed. When `self` is greater than 25 ("z"), subsequent values
    /// will have two characters. (26 = "aa", 27 = "ab", 28 = "ac", etc.) This fails gracefully after
    /// value 701 ("zz"), and just rolls back over to "aa" at 702.
    public func alphabeticalRepresentation() -> String {
        let positiveSelf = abs(self)
        var retString: String = Int.alphabet[positiveSelf % Int.alphabet.count]
        if positiveSelf >= Int.alphabet.count {
            let multiples: Int = positiveSelf / Int.alphabet.count
            let multipleString = Int.alphabet[(multiples-1) % Int.alphabet.count]
            retString = "\(multipleString)\(retString)"
        }
        return retString
    }

}

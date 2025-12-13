import Foundation

extension UserDefaults {

    private enum Keys: String {
        case currentHexGridConfig
    }

    var currentHexGridConfig: HexGridConfig? {
        get {
            guard let rawData = Self.standard.data(forKey: Keys.currentHexGridConfig.rawValue),
                  let data = try? JSONDecoder().decode(HexGridConfig.self, from: rawData) else {
                return nil
            }
            return data
        } set {
            if let newValue {
                Self.standard.set(try? JSONEncoder().encode(newValue), forKey: Keys.currentHexGridConfig.rawValue)
            } else {
                Self.standard.set(nil, forKey: Keys.currentHexGridConfig.rawValue)
            }
        }
    }

}

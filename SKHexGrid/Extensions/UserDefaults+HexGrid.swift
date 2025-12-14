import Foundation

extension UserDefaults {

    private enum Keys: String {
        case currentHexGridConfig
        case saveHexGridDataNamesArray
        case saveHexGridDataPrefix
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

    var saveHexGridDataNamesArray: [String] {
        get {
            return Self.standard.stringArray(forKey: Keys.saveHexGridDataNamesArray.rawValue) ?? []
        } set {
            Self.standard.set(newValue, forKey: Keys.saveHexGridDataNamesArray.rawValue)
        }
    }

    func saveHexGridConfig(_ config: HexGridConfig, withName name: String) {
        let key = "\(Keys.saveHexGridDataPrefix.rawValue)-\(name)"
        Self.standard.set(try? JSONEncoder().encode(config), forKey: key)
        var namesArray = self.saveHexGridDataNamesArray.filter { $0 != name }
        namesArray.insert(name, at: 0)
        self.saveHexGridDataNamesArray = namesArray
    }

    func savedHexGridConfig(named name: String) -> HexGridConfig? {
        let key = "\(Keys.saveHexGridDataPrefix.rawValue)-\(name)"
        guard let rawData = Self.standard.data(forKey: key),
              let data = try? JSONDecoder().decode(HexGridConfig.self, from: rawData) else {
            return nil
        }
        return data
    }

}

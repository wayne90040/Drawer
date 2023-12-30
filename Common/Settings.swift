import Foundation

class Settings {
    static let shared = Settings()
    
    let defaults = UserDefaults.standard
    
    enum Keys: String {
        case model
        case safetyCheckerDisclaimer
        case computUnits
    }
    
    private init() {
        defaults.register(defaults: [
            Keys.model.rawValue: "",
            Keys.safetyCheckerDisclaimer.rawValue: "",
            Keys.computUnits.rawValue: -1
        ])
    }
}

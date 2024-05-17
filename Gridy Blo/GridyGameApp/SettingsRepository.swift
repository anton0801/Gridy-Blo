import Foundation

class SettingsRepository: ObservableObject {
    
    @Published var isVibrationEnabled = UserDefaults.standard.bool(forKey: "isVibrationEnabled") {
        didSet {
            UserDefaults.standard.set(isVibrationEnabled, forKey: "isVibrationEnabled")
        }
    }
    
    @Published var isMusicEnabled = UserDefaults.standard.bool(forKey: "isMusicEnabled") {
        didSet {
            UserDefaults.standard.set(isMusicEnabled, forKey: "isMusicEnabled")
        }
    }
    
    @Published var isSoundsEnabled = UserDefaults.standard.bool(forKey: "isSoundsEnabled") {
        didSet {
            UserDefaults.standard.set(isSoundsEnabled, forKey: "isSoundsEnabled")
        }
    }
    
}

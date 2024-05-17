import Foundation

class LivesRepository: ObservableObject {
    
    @Published var livesAvailable = 3 {
        didSet {
            UserDefaults.standard.set(livesAvailable, forKey: "lives_available")
        }
    }
    
    
    
}

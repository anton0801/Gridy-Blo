import Foundation
import Combine

class LivesRepository: ObservableObject {
    
    @Published var livesAvailable = UserDefaults.standard.integer(forKey: "lives_available") {
        didSet {
            UserDefaults.standard.set(livesAvailable, forKey: "lives_available")
            UserDefaults.standard.set(Date(), forKey: "live_minus_last_date")
        }
    }
    
    @Published var timeRemaining: TimeInterval = 30 * 60
    private var timer: AnyCancellable?
    private let userDefaultsKey = "live_minus_last_date"
    private let maxLives = 3
    private let interval: TimeInterval = 30 * 60
    
    init() {
        if livesAvailable < 3 {
            startTimer()
        }
    }
        
    private func startTimer() {
        timer?.cancel()
        
        if let lastDate = UserDefaults.standard.object(forKey: userDefaultsKey) as? Date {
            let now = Date()
            let timePassed = now.timeIntervalSince(lastDate)
            
            if timePassed >= interval {
                let livesToAdd = min(Int(timePassed / interval), maxLives - livesAvailable)
                livesAvailable = min(livesAvailable + livesToAdd, maxLives)
                
                UserDefaults.standard.set(now, forKey: userDefaultsKey)
                timeRemaining = interval
            } else {
                timeRemaining = interval - timePassed
            }
        } else {
            UserDefaults.standard.set(Date(), forKey: userDefaultsKey)
            timeRemaining = interval
        }
        
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }
    
    private func tick() {
        timeRemaining -= 1
        
        if timeRemaining <= 0 {
            if livesAvailable < maxLives {
                livesAvailable += 1
                UserDefaults.standard.set(Date(), forKey: userDefaultsKey)
                timeRemaining = interval
            } else {
                timeRemaining = 0
                timer?.cancel()
                UserDefaults.standard.set(nil, forKey: userDefaultsKey)
            }
        }
    }
    
    func resetTimer() {
        UserDefaults.standard.set(Date(), forKey: userDefaultsKey)
        timeRemaining = interval
        startTimer()
    }
    
}

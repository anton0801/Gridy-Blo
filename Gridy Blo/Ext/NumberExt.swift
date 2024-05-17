import Foundation

extension Int {
    func formatSecondsToMinutesAndSeconds() -> String {
        let minutes = self / 60
        let remainingSeconds = self % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

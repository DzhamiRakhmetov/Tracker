import Foundation

final class OnboardingManager {
    
    static let onboardingKey = "OnboardingCompleted"
    
    static var isOnboardingCompleted: Bool {
        get {
            return UserDefaults.standard.bool(forKey: onboardingKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: onboardingKey)
        }
    }
}

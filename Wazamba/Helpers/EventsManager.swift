import Foundation

enum Event {
    case statusFalse, cantFetchStatus, brokenURL
}

struct EventsManager {
    
    static let shared = EventsManager()
    
    func sendEvent(_ event: Event) {
        
    }
}

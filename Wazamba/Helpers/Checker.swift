import UIKit
import Firebase
import FirebaseAnalytics

struct HomeTrack: Decodable {
    var home: String
    var track: String
}

class Checker {

    private init() {}
    static let shared = Checker()

    func checkEveryting(completion: @escaping (_ url: URL?) -> ()) {

        
        if let url = Checker.savedHomeTrack {
            completion(url)
            return
        }

        self.getTrackUrl { track in
            completion(track)
        }

    }

    // get home or track if it's stored
    static var savedHomeTrack: URL? {
        let homeURL = UserDefaultsManager.home
        let trackURL = UserDefaultsManager.track

        if UserDefaultsManager.didReg {
            return homeURL
        } else {
            return trackURL
        }
    }

    func getStatus(firebaseID: String, completion: @escaping (HomeTrack?) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = Consts.dynamicTutorial
        urlComponents.path = "/prod"

        urlComponents.queryItems = [
            URLQueryItem(name: "uuid", value: firebaseID),
            URLQueryItem(name: "app", value: Consts.appID)
        ]

        guard let url = urlComponents.url else {
            completion(nil)
            return
        }

        print("requesting: \(url.absoluteString)")

        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(nil)
                return
            }

            do {
                let finalURL = try JSONDecoder().decode(HomeTrack.self, from: data)
                completion(finalURL)
            } catch let jsonError {
                print("Failed to decode JSON", jsonError.localizedDescription)
                completion(nil)
            }
        }
        dataTask.resume()
    }

    func getTrackUrl(completion: @escaping (_ track: URL?) -> ()) {

        Messaging.messaging().token { (result, error) in

            let firebaseID = result ?? "noFirebaseID"
            print(firebaseID)
            self.getStatus(firebaseID: firebaseID) { trackHome in
                if let trackHome = trackHome {
                    UserDefaultsManager.home = URL(string: trackHome.home)
                    let track = URL(string: trackHome.track)
                    UserDefaultsManager.track = track
                    completion(track)
                    print(track)
                } else {
                    completion(nil)
                }
            }
        }
    }

    func getState(completion: @escaping (_ isOpen: String) -> ()) {
        let ref = Database.database().reference()
        ref.child("status").getData { (error, snapshot) in
            if let value = snapshot.value as? String {
                completion(value)
            } else {
                print("can't fetch is opened value")
                completion("")
            }
        }
    }

}

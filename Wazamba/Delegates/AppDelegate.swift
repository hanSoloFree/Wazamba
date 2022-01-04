//import UIKit
//import Firebase
//
//@main
//class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
//
//    var window: UIWindow?
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        setUpFirebase()
//        playSound()
//
//        UserDefaultsManager.reg()
//
//        UIApplication.shared.isIdleTimerDisabled = true
//        application.registerForRemoteNotifications()
//
//
//        setInitVC()
//        return true
//    }
//
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//    }
//
//    func setInitVC() {
//        self.window = UIWindow()
//        self.window?.rootViewController = InitialViewController()
//        self.window?.makeKeyAndVisible()
//    }
//
//    func setUpFirebase() {
//        FirebaseApp.configure()
//        UNUserNotificationCenter.current().delegate = self
//        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
//        Messaging.messaging().delegate = self
//
//        Messaging.messaging().token { (result, error) in
//            if let error = error {
//                print("Error fetching remote instance ID: \(error)")
//            } else if let result = result {
//                print("Remote instance ID token: \(result)")
//            }
//        }
//    }
//}
//
//extension AppDelegate: UNUserNotificationCenterDelegate {
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//
//        SegmentManager.handlePushNotification(userInfo)
//    }
//}
//


import UIKit
import Firebase


@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                
        setUpFirebase()

        UserDefaultsManager.reg()
        
        UIApplication.shared.isIdleTimerDisabled = true
        application.registerForRemoteNotifications()
        
        setInitVC()
        playSound()
        return true
    }
    
    func setInitVC() {
        self.window = UIWindow()
        self.window?.rootViewController = InitialViewController()
        self.window?.makeKeyAndVisible()
    }
    

    func setUpFirebase() {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
        Messaging.messaging().delegate = self
        
        Messaging.messaging().token { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result)")
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
 
        SegmentManager.handlePushNotification(userInfo)
    }
}

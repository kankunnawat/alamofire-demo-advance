import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // MARK: - Comment out this line to startNetworkMonitoring
//        GitNetworkReachability.shared.startNetworkMonitoring()
        return true
    }
}

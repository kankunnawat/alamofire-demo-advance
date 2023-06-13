import UIKit
import Alamofire

class GitNetworkReachability {
    static let shared = GitNetworkReachability()
    let offlineAlertController: UIAlertController = {
        UIAlertController(title: "No Network", message: "Please connect to network and try again", preferredStyle: .alert)
    }()

    func showOfflineAlert() {
        let rootViewController = UIApplication.shared.windows.first?.rootViewController
        rootViewController?.present(offlineAlertController, animated: true, completion: nil)
    }

    func dismissOfflineAlert() {
        let rootViewController = UIApplication.shared.windows.first?.rootViewController
        rootViewController?.dismiss(animated: true, completion: nil)
    }
}

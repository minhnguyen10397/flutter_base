import Foundation
import UIKit

class FlutterHelper {
    private static func topViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }),
              let rootViewController = window.rootViewController else {
            return nil
        }
        
        var topViewController = rootViewController
        while let presented = topViewController.presentedViewController {
            topViewController = presented
        }
        
        return topViewController
    }
    
    static func openFlutter() {
        guard let topVC = topViewController() else { return }
        FlutterManager.shared.openFlutter(parentViewController: topVC)
    }
    
    static func closeFlutter() {
        FlutterManager.shared.closeFlutter()
    }
    
    /// Set cho phép click Flutter view hay không
    static func setAllowFlutterInteraction(_ allow: Bool) {
        FlutterManager.shared.setAllowFlutterInteraction(allow)
    }
}


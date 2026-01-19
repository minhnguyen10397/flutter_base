import Foundation

class FlutterHelper {
    static func openFlutter() {
        FlutterManager.shared.openFlutter()
    }
    
    static func closeFlutter() {
        FlutterManager.shared.closeFlutter()
    }
    
    /// Set cho phép click Flutter view hay không
    static func setAllowFlutterInteraction(_ allow: Bool) {
        FlutterManager.shared.setAllowFlutterInteraction(allow)
    }
}


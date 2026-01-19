import Foundation
import Flutter
import UIKit

class TransparentPassThroughView: UIView {
    weak var flutterManager: FlutterManager?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if flutterManager?.allowFlutterInteraction == true {
            return super.hitTest(point, with: event)
        }
        return nil
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if flutterManager?.allowFlutterInteraction == true {
            return super.point(inside: point, with: event)
        }
        return false
    }
}

class TransparentPassThroughWindow: UIWindow {
    weak var flutterManager: FlutterManager?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if flutterManager?.allowFlutterInteraction == true {
            return super.hitTest(point, with: event)
        }
        return nil
    }
}

class FlutterManager {
    static let shared = FlutterManager()
    
    private var flutterViewController: FlutterViewController?
    private var flutterEngine: FlutterEngine?
    private var flutterWindow: UIWindow?
    
    var allowFlutterInteraction: Bool = false
    
    private init() {}
    
    func setup(engine: FlutterEngine) {
        self.flutterEngine = engine
        engine.run()
    }
    
    func openFlutter() {
        guard let engine = flutterEngine else { return }
        
        if flutterViewController == nil {
            let flutterVC = FlutterViewController(engine: engine, nibName: nil, bundle: nil)
            flutterVC.view.backgroundColor = UIColor.clear
            flutterViewController = flutterVC
        }
        
        guard let flutterVC = flutterViewController,
              let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        
        let flutterWindow = TransparentPassThroughWindow(windowScene: windowScene)
        flutterWindow.flutterManager = self
        flutterWindow.backgroundColor = UIColor.clear
        flutterWindow.isOpaque = false
        flutterWindow.frame = UIScreen.main.bounds
        flutterWindow.isUserInteractionEnabled = true
        
        class TransparentContainerViewController: UIViewController {
            weak var flutterManager: FlutterManager?
            
            override func loadView() {
                let transparentView = TransparentPassThroughView()
                transparentView.flutterManager = flutterManager
                transparentView.backgroundColor = UIColor.clear
                transparentView.frame = UIScreen.main.bounds
                self.view = transparentView
            }
        }
        
        let containerVC = TransparentContainerViewController()
        containerVC.flutterManager = self
        containerVC.addChild(flutterVC)
        containerVC.view.addSubview(flutterVC.view)
        flutterVC.view.frame = containerVC.view.bounds
        flutterVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        flutterVC.didMove(toParent: containerVC)
        
        flutterWindow.rootViewController = containerVC
        flutterWindow.windowLevel = UIWindow.Level.alert + 1
        self.flutterWindow = flutterWindow
        flutterWindow.makeKeyAndVisible()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.allowFlutterInteraction = true
        }
    }
    
    func closeFlutter() {
        guard let flutterWindow = flutterWindow else { return }
        UIView.animate(withDuration: 0.3, animations: {
            flutterWindow.alpha = 0
        }) { _ in
            flutterWindow.isHidden = true
            self.flutterWindow = nil
        }
    }
    
    func setAllowFlutterInteraction(_ allow: Bool) {
        allowFlutterInteraction = allow
    }
}


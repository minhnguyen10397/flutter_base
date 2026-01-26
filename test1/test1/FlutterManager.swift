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

class FlutterPassThroughView: UIView {
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


class FlutterManager {
    static let shared = FlutterManager()
    
    private var flutterViewController: FlutterViewController?
    private var flutterEngine: FlutterEngine?
    private var flutterWrapperView: FlutterPassThroughView?
    private weak var parentViewController: UIViewController?
    
    var allowFlutterInteraction: Bool = false
    
    private init() {}
    
    func setup(engine: FlutterEngine) {
        self.flutterEngine = engine
        engine.run()
    }
    
    func openFlutter(parentViewController: UIViewController) {
        guard let engine = flutterEngine else { return }
        
        // Nếu đã mở rồi thì return
        if flutterWrapperView != nil {
            return
        }
        
        if flutterViewController == nil {
            let flutterVC = FlutterViewController(engine: engine, nibName: nil, bundle: nil)
            flutterVC.view.backgroundColor = UIColor.clear
            flutterViewController = flutterVC
        }
        
        guard let flutterVC = flutterViewController else { return }
        
        // Wrap Flutter view trong FlutterPassThroughView để handle touch pass-through
        let wrapperView = FlutterPassThroughView()
        wrapperView.flutterManager = self
        wrapperView.backgroundColor = UIColor.clear
        wrapperView.frame = parentViewController.view.bounds
        wrapperView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.flutterWrapperView = wrapperView
        
        // Add Flutter view controller như child view controller
        parentViewController.addChild(flutterVC)
        wrapperView.addSubview(flutterVC.view)
        flutterVC.view.frame = wrapperView.bounds
        flutterVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        flutterVC.view.backgroundColor = UIColor.clear
        flutterVC.didMove(toParent: parentViewController)
        
        // Add wrapper view vào parent view
        parentViewController.view.addSubview(wrapperView)
        self.parentViewController = parentViewController
        
        // Update user interaction
        updateUserInteraction()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.allowFlutterInteraction = true
            self.updateUserInteraction()
        }
    }
    
    func closeFlutter() {
        guard let flutterVC = flutterViewController,
              let wrapperView = flutterWrapperView,
              let parentVC = parentViewController else { return }
        
        // Remove Flutter view controller
        flutterVC.willMove(toParent: nil)
        wrapperView.removeFromSuperview()
        flutterVC.removeFromParent()
        
        self.flutterWrapperView = nil
        self.parentViewController = nil
    }
    
    func setAllowFlutterInteraction(_ allow: Bool) {
        allowFlutterInteraction = allow
        updateUserInteraction()
    }
    
    private func updateUserInteraction() {
        let allow = allowFlutterInteraction
        flutterWrapperView?.isUserInteractionEnabled = true // Phải true để hitTest được gọi
        flutterViewController?.view.isUserInteractionEnabled = allow
    }
}


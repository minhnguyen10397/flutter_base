import SwiftUI
import Flutter

// AppDelegate giữ FlutterEngine dùng chung cho toàn app
class AppDelegate: NSObject, UIApplicationDelegate {
    lazy var flutterEngine = FlutterEngine(name: "my_flutter_engine")

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Khởi động engine sớm
        flutterEngine.run()
        
        // Setup FlutterManager
        FlutterManager.shared.setup(engine: flutterEngine)
        
        return true
    }
}

@main
struct test1App: App {
    // Kết nối AppDelegate vào SwiftUI App
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
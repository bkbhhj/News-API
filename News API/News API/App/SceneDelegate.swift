import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
    // MARK: setup RootViewController
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let assembly = Asembly()
    let newsViewController = assembly.configureNewsModule()
    let navigationViewController = UINavigationController(rootViewController: newsViewController)
    window = UIWindow(windowScene: windowScene)
    window?.rootViewController = navigationViewController
    window?.makeKeyAndVisible()
  }
}

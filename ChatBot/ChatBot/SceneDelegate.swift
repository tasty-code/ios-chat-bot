import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        var messages: [Message] = []
        let text: String = "쫑쫑쫑"

        for times in 1...20 {
            let randomRole = [Role.user, Role.assistant].randomElement()!
            let randomContent = {
                var temp = ""
                for _ in 1..<times {
                    temp += text
                }
                return temp
            }()
            
            let message = Message(role: randomRole, content: randomContent)
            messages.append(message)
        }
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = ChattingRoomViewController(messages: messages)
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }
    func sceneDidBecomeActive(_ scene: UIScene) { }
    func sceneWillResignActive(_ scene: UIScene) { }
    func sceneWillEnterForeground(_ scene: UIScene) { }
    func sceneDidEnterBackground(_ scene: UIScene) { }
}

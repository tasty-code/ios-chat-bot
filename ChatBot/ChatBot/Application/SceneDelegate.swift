//
//  SceneDelegate.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        
        let viewModel = GPTChatRoomViewModel.init(
            httpService: Network.GPTHTTPService(encoder: JSONEncoder(), decoder: JSONDecoder()),
            httpRequest: Network.GPTRequest.chatBot(apiKey: Bundle.main.object(forInfoDictionaryKey: "CHAT_BOT_API_KEY") as! String),
            chattings: []
        )
        window?.rootViewController = GPTChatRoomViewController(viewModel: viewModel)
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }
    func sceneDidBecomeActive(_ scene: UIScene) { }
    func sceneWillResignActive(_ scene: UIScene) { }
    func sceneWillEnterForeground(_ scene: UIScene) { }
    func sceneDidEnterBackground(_ scene: UIScene) { }
}

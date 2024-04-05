import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let requester = URLSession.shared
        // TODO: Literals...!
        let networkManager = NetworkService(
            requester: requester,
            decoder: jsonDecoder
        )
        let viewModel = MainViewModel(networkService: networkManager)
        window?.rootViewController = MainViewController(viewModel: viewModel)
        window?.makeKeyAndVisible()
    }
}

import UIKit
import Combine

final class ViewController: UIViewController {
    private let chatViewModel = ChatViewModel(networkManager: OpenAINetworkManager())
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendUserMessage()
        sendSystemMessage()
    }
    
    private func sendUserMessage() {
        chatViewModel.sendMessage(role: Role.user.rawValue, content: "내일 추울까?")
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { response in
                print("user: \(response)")
            }
            .store(in: &cancellables)
    }
    
    private func sendSystemMessage() {
        chatViewModel.sendMessage(role: Role.system.rawValue, content: "내일 추울까?")
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { response in
                print("system: \(response)")
            }.store(in: &cancellables)
    }
}


import UIKit
import Combine

final class ViewController: UIViewController {
    private let chatViewModel = ChatViewModel(networkManager: OpenAINetworkManager())
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        sendMessageAsUser()
        sendMessageAsSystem()
    }
    
    private func bindViewModel() {
        chatViewModel.$userResponse
            .sink { response in
                if let response = response {
                    if let message = response.choices.first?.message.content {
                        print("user: \(message)")
                    }
                }
            }
            .store(in: &cancellables)
        
        chatViewModel.$systemResponse
            .sink { response in
                if let response = response {
                    if let message = response.choices.first?.message.content {
                        print("system: \(message)")
                    }
                }
            }.store(in: &cancellables)
        
        chatViewModel.$networkError
            .sink { error in
                if let error = error {
                    print(error)
                }
            }
            .store(in: &cancellables)
    }
    
    private func sendMessageAsUser() {
        chatViewModel.sendMessage(role: Role.user.rawValue, content: "내일 추울까?")
    }
    
    private func sendMessageAsSystem() {
        chatViewModel.sendMessage(role: Role.system.rawValue, content: "내일 추울까?")
    }
}


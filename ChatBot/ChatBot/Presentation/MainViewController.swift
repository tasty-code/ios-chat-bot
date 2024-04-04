import UIKit
import Combine

final class MainViewController: UIViewController {
    private let viewModel: MainViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        sendMessageAsUser()
        sendMessageAsSystem()
    }
    
    private func bindViewModel() {
        viewModel.$userResponse
            .sink { response in
                if let response = response {
                    if let message = response.choices.first?.message.content {
                        print("user: \(message)")
                    }
                }
            }
            .store(in: &cancellables)
        
        viewModel.$systemResponse
            .sink { response in
                if let response = response {
                    if let message = response.choices.first?.message.content {
                        print("system: \(message)")
                    }
                }
            }.store(in: &cancellables)
        
        viewModel.$networkError
            .sink { error in
                if let error = error {
                    print(error)
                }
            }
            .store(in: &cancellables)
    }
    
    private func sendMessageAsUser() {
        viewModel.sendMessage(role: .user, content: "내일 추울까?")
    }
    
    private func sendMessageAsSystem() {
        viewModel.sendMessage(role: .system, content: "내일 추울까?")
    }
}


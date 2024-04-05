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
    }
    
    private func bindViewModel() {
        viewModel.$userResponse
            .sink { response in
                if let response = response {
                    guard
                        let role = response.choices.first?.message.role,
                        let message = response.choices.first?.message.content
                    else {
                        return // TODO: 어떻게 처리하는 것이 정석일까
                    }
                    print("\(role): \(message)")
                }
            }
            .store(in: &cancellables)
        
        viewModel.$networkError
            .sink { error in
                if let error = error {
                    print(error)
                }
            }
            .store(in: &cancellables)
    }
    
    private func sendMessageAsUser() {
        viewModel.sendMessage(content: "내일 추울까?")
    }
}


//
//  ViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class ChatBotViewController: UIViewController {
    let button = UIButton().then {
        $0.setTitle("이거", for: .normal)
        $0.setTitleColor(.red, for: .normal)
    }
    
    private let chatBotViewModel: ChatBotViewModel
    let disposeBag = DisposeBag()
    let chatTrigger = PublishSubject<Message>()
    
    init(chatBotViewModel: ChatBotViewModel) {
        self.chatBotViewModel = chatBotViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension ChatBotViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackground()
        bindViewModel()
        bindView()
    }
}

// MARK: - Private Method
private extension ChatBotViewController {
    func configureBackground() {
        view.backgroundColor = .white
        self.view.addSubview(button)
        button.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
    }
    
    func bindViewModel() {
        let input = ChatBotViewModel.Input(chatTigger: chatTrigger)
        
        let output = chatBotViewModel.transform(input: input)
        output.resultChat
            .observe(on: MainScheduler.instance)
            .bind { result in
            switch result {
            case .success(let data):
                print("RESULT === \(data)")
            case .failure(let error):
                let okAction = UIAlertAction(title: "확인", style: .default)
                self.showMessageAlert(message: "\(error.localizedDescription)", action: [okAction])
            }
        }
        .disposed(by: disposeBag)
    }
    
    func bindView() {
        button.rx.tap.bind { [weak self] _ in
            self?.chatTrigger.onNext(Message(role: "user", content: "집언제감?"))
        }.disposed(by: disposeBag)
    }
}

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

class ChatBotViewController: UIViewController {
    let button = UIButton().then {
        $0.setTitle("이거", for: .normal)
        $0.setTitleColor(.red, for: .normal)
    }
    private let chatBotViewModel: ChatBotViewModel
    let disposeBag = DisposeBag()
    let chatTrigger = PublishSubject<Void>()
    
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
        output.resultChat.bind { result in
            switch result {
            case .success(let chat):
                print(chat)
            case .failure(let error):
                print(error)
            }
        }.disposed(by: disposeBag)
    }
    
    func bindView() {
        button.rx.tap.bind { [weak self] _ in
            self?.chatTrigger.onNext(Void())
        }.disposed(by: disposeBag)
    }
}

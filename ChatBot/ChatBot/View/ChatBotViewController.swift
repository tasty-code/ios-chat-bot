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

final class ChatBotViewController: UIViewController {
    private let chatInputTextView = ChatInputTextView()
    private lazy var chatList = ChatBotListView()
    private let chatBotViewModel: ChatBotViewModel
    private var messageList: [Message] = []
    
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
        chatList.dataSource = self
        setupView()
        setupSubview()
        bindViewModel()
        bindView()
        addTapGesture()
        setupConstraint()
    }
}

// MARK: - Private Method
private extension ChatBotViewController {
    func setupView() {
        view.backgroundColor = .white
    }
    
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func handleTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func setupSubview() {
        view.addSubview(chatList)
        view.addSubview(chatInputTextView)
    }
    
    func setupConstraint() {
        chatList.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(chatInputTextView.snp.top)
        }
        
        chatInputTextView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
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
                    let message = Message(role: "assistant", content: data.choices[0].message.content)
                    self.messageList.append(message)
                    self.chatList.reloadData()
                case .failure(let error):
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    self.showMessageAlert(message: "\(error.localizedDescription)", action: [okAction])
                }
            }
            .disposed(by: disposeBag)
    }
    
    func bindView() {
        chatInputTextView.enterButton.rx.tap.bind { [weak self] _ in
            guard
                let userInputText = self?.chatInputTextView.inputTextField.text
            else {
                return
            }
            
            let userMessage = Message(role: "user", content: userInputText)
            
            self?.chatTrigger.onNext(userMessage)
            self?.messageList.append(userMessage)
            self?.chatList.reloadData()
        }.disposed(by: disposeBag)
    }
}

extension ChatBotViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = chatList.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChatBotMessageCell
        cell.setupMessageText(message: messageList[indexPath.row], type: messageList[indexPath.row].role)
        return cell
    }
}

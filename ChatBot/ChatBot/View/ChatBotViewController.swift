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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("tapped view")
        self.view.endEditing(true)
    }
    
    var messageList: [Message] = []
    
    lazy var chatList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(ChatBotMessageCell.self, forCellWithReuseIdentifier: "cell")
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .white
        return view
    }()
    
    lazy var enterButton = UIButton().then {
        $0.setImage(UIImage(systemName: "arrowshape.up.circle"), for: .normal)
        $0.tintColor = .blue
        $0.titleLabel?.font = .systemFont(ofSize: 14)
        $0.setTitleColor(.blue, for: .normal)
    }
    
    lazy var inputTextField = UITextField().then {
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.masksToBounds = false
        $0.placeholder = "메세지를 입력해주세요."
    }
    
    lazy var inputStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fillProportionally
         
         $0.addArrangedSubview(inputTextField)
         $0.addArrangedSubview(enterButton)
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
        view.backgroundColor = .white
        setupConstraint()
        bindViewModel()
        bindView()
    }
}

// MARK: - Private Method
private extension ChatBotViewController {
    func setupConstraint() {
        view.addSubview(chatList)
        view.addSubview(inputStackView)
        
        chatList.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(inputStackView.snp.top)
            
            inputStackView.snp.makeConstraints { make in
//                make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
                make.leading.trailing.equalTo(view.safeAreaLayoutGuide).offset(20)
                make.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top)
            }
            
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
                    print(message)
                case .failure(let error):
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    self.showMessageAlert(message: "\(error.localizedDescription)", action: [okAction])
                }
            }
            .disposed(by: disposeBag)
    }
    
    
    func bindView() {
        enterButton.rx.tap.bind { [weak self] _ in
            self?.chatTrigger.onNext(Message(role: "user", content: self?.inputTextField.text ?? ""))
        }.disposed(by: disposeBag)
    }
}

extension ChatBotViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = chatList.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChatBotMessageCell
        cell.setupMessageText(message: messageList[indexPath.row])
        return cell
    }
}

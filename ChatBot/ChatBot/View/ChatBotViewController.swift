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
        setupConstraint()
        bindViewModel()
    }
}

// MARK: - Private Method
private extension ChatBotViewController {
    
    private func setupConstraint() {
        view.addSubview(chatList)
        
        chatList.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
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
                    self.chatBotViewModel.chatList.append(data)
                case .failure(let error):
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    self.showMessageAlert(message: "\(error.localizedDescription)", action: [okAction])
                }
            }
            .disposed(by: disposeBag)
    }
}

extension ChatBotViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.chatBotViewModel.chatList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = chatList.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChatBotMessageCell
        cell.setupMessageText(message: chatBotViewModel.chatList[indexPath.row].choices[0].message)
        return cell
    }
    
    

}

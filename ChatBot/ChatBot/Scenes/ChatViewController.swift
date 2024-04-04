//
//  ChatViewController.swift
//  ChatBot
//
//  Created by Kim EenSung on 3/29/24.
//

import UIKit

import RxSwift

/// 채팅 뷰 컨트롤러
final class ChatViewController: UIViewController {
    private let chatTextView = ChatTextView()
    private lazy var chatCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
    
    private let chatViewModel = ChatViewModel()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setUpChatCollectionView()
        initializeHideKeyboard()
        registerButton()
    }
}

// MARK: - UI
extension ChatViewController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(chatCollectionView)
        view.addSubview(chatTextView)
        
        chatCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(chatTextView.snp.top)
        }
        
        chatTextView.snp.makeConstraints {
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            $0.width.equalTo(view.safeAreaLayoutGuide.snp.width).inset(20)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
        }
    }
}

// MARK: - Private Methods
extension ChatViewController {
    private func registerButton() {
        chatTextView.sendButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let text = self?.chatTextView.textView.text else {
                    return
                }
                
                self?.chatViewModel.updateMessage(with: text)
            })
            .disposed(by: bag)
    }
    
    private func initializeHideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - ChatCollectionView
extension ChatViewController {
    private func setUpChatCollectionView() {
        chatCollectionView.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: ChatCollectionViewCell.className)
        
        chatViewModel.setDataSource(collectionView: chatCollectionView)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = false
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}

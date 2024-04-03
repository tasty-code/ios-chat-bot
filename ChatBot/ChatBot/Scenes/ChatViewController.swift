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
    private var dataSource: UICollectionViewDiffableDataSource<Section, String>?
    private let service = ChatAPIService()
    private let bag = DisposeBag()
    private var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
    
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
            .subscribe(onNext: {
                guard let text = self.chatTextView.textView.text else {
                    return
                }
                self.service.createChat(systemContent: "Hello! How can I assist you today?",
                                   userContent: text)
                    .subscribe(onSuccess: { result in
                        guard let message = result?.choices[0].message.content else {
                            return
                        }
                        self.snapshot.appendSections([.main])
                        self.snapshot.appendItems([message])
                        self.dataSource?.apply(self.snapshot)
                    }, onFailure: { error in
                        print(error)
                    })
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
    enum Section {
        case main
    }

    private func setUpChatCollectionView() {
        chatCollectionView.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: ChatCollectionViewCell.className)
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: chatCollectionView) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatCollectionViewCell.className, for: indexPath) as? ChatCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.text(itemIdentifier, isUser: false)
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(["test1", "test2", "test3", "test4"])
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = false
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}

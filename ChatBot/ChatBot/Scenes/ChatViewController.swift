//
//  ChatViewController.swift
//  ChatBot
//
//  Created by Kim EenSung on 3/29/24.
//

import UIKit

/// 채팅 뷰 컨트롤러
final class ChatViewController: UIViewController {
    private let textInputView = ChatTextView()
    private lazy var chatCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        initializeHideKeyboard()
    }
}

// MARK: - UI
extension ChatViewController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(chatCollectionView)
        view.addSubview(textInputView)
        
        chatCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(textInputView.snp.top)
        }
        
        textInputView.snp.makeConstraints {
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            $0.width.equalTo(view.safeAreaLayoutGuide.snp.width).inset(20)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
        }
    }
}

// MARK: - Private Methods
extension ChatViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: config)
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

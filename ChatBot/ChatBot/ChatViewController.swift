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
        
        view.addSubview(textInputView)
        
        textInputView.snp.makeConstraints {
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            $0.width.equalTo(view.safeAreaLayoutGuide.snp.width).inset(20)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
        }
    }
}

// MARK: - Private Methods
extension ChatViewController {
    private func initializeHideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
//        textInputView.dismissKeyboard()
        view.endEditing(true)
    }
}

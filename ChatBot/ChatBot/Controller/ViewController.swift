//
//  ViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit

final class ViewController: UIViewController {
    private let chatView = ChatView()
    override func loadView() {
        self.view = chatView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        chatView.setTextViewDelegate(self)
    }
}

// MARK: - About TextView Keyboard

extension ViewController {
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

extension ViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.frame.height > view.frame.height / 9 {
            chatView.limitTextViewHeight()
            textView.isScrollEnabled = true
        }
    }
}

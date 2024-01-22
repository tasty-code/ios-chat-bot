//
//  ViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit

final class ViewController: UIViewController {
    
    private let chatView = ChatView()
    private let endPoint = EndPointMaker()
    static let chatUIItem = Message(role: "indicator", content: "메세지 수신중..(임시)")
    
    override func loadView() {
        self.view = chatView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        chatView.setTextViewDelegate(self)
        chatView.delegate = self
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Delegate

extension ViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        guard textView.contentSize.height < view.frame.height * 0.1
        else {
            textView.isScrollEnabled = true
            return
        }
        
        textView.isScrollEnabled = false
        textView.constraints.forEach { constraint in
            guard constraint.firstAttribute != .height
            else {
                constraint.constant = textView.estimatedSizeHeight
                return
            }
        }
    }
}

extension ViewController: ChatViewDelegate {
    func submitUserMessage(chatView: ChatView, userMessage: String) {
        let snapShotItems = [Message(role: "user", content: userMessage), ViewController.chatUIItem]
        
        chatView.updateSnapshot(items: snapShotItems, isFetched: false)
        chatView.scrollToBottom()
        guard let endpoint = endPoint.buildEndpoint(userMessage) else {
            return
        }
        
        NetworkingManager.shared.downloadData(request: endpoint.generateRequest(),
                                              to: AIContentModel.self) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    self?.chatView.updateSnapshot(items: [data.choices[0].message], isFetched: true)
                    chatView.toggleSendButton()
                    chatView.scrollToBottom()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

//
//  ViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit

final class ChatRoomViewController: UIViewController {
    
    // MARK: - properties

    private let chatView = ChatView()
    private var endPoint: Endpointable = ChatBotEndpoint()
    private var historyMessages: [Message] = [Message]()
    
    // MARK: - view life cycle

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
}

// MARK: - private methods

extension ChatRoomViewController {
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Delegate methods
extension ChatRoomViewController: UITextViewDelegate {
    
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

extension ChatRoomViewController: ChatViewDelegate {
    func submitUserMessage(chatView: ChatView, animationData: Message, userMessage: String) {
        let newMessage = Message(role: UserContentConstant.userRole, content: userMessage)
        historyMessages.append(newMessage)
        
        endPoint.httpBodyContent.messages = historyMessages
        
        let snapShotItems = [newMessage, animationData]
        chatView.updateSnapshot(items: snapShotItems, isFetched: false)
        chatView.scrollToBottom()
        
        NetworkingManager.shared.downloadData(endpoint: endPoint,
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


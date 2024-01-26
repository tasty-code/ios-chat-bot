//
//  ChattingViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit


// MARK: - ViewController

final class ChattingViewController: UIViewController {
    
    private let chatService = ChatService(url: OpenAIURL(path: .chat), httpMethod: .post, contentType: .json)
    private var chatRoomView: ChatRoomView!
    
    override func loadView() {
        super.loadView()
        chatRoomView = ChatRoomView(delegate: self)
        view = chatRoomView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}

extension ChattingViewController: ChatTextInputViewButtonDelegate {
    func sendMessage(_ message: String) {
        let chatRecord = chatService.addRecord(messages: [Message(role: .user, content: message),
                                                          Message(role: .assistant, content: "")])
        chatRoomView.updateCollectionView(data: chatRecord)
        
        Task {
            let responseChatRecord = await chatService.sendRequestDTO()
            chatRoomView.updateCollectionView(data: responseChatRecord)
        }
    }
}

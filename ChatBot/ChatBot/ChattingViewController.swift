//
//  ChattingViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit

// MARK: - ViewController

final class ChattingViewController: UIViewController {
    private var chatService: ServiceProvider!
    private var chatRoomView: ChatRoomView!
    
    override func loadView() {
        super.loadView()
        chatService = ServiceProvider(delegate: self)
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
        Task {
            let chatRecord = await chatService.sendRequestDTO(message: message)
            chatRoomView.updateCollectionView(data: chatRecord)
        }
    }
}

extension ChattingViewController: UpdateUIDelegate {
    func updateUI(message: [Message]) {
        chatRoomView.updateCollectionView(data: message)
    }
}

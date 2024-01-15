//
//  ViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit
import Combine

final class GPTChatRoomViewController: UIViewController {
    enum Section {
        case main
    }
    
    private let viewModel: GPTChatRoomVMProtocol
    private let cellResistration = UICollectionView.CellRegistration<GPTChatRoomCell, Model.GPTMessage> { cell, indexPath, itemIdentifier in
        cell.configureCell(to: itemIdentifier)
    }
    
    private var chatRoomView: GPTChatRoomView!
    private var cancellables = Set<AnyCancellable>()
    private var chattingDataSource: UICollectionViewDiffableDataSource<Section, Model.GPTMessage>!
    
    init(viewModel: GPTChatRoomVMProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatRoomView = GPTChatRoomView()
        chatRoomView.sendButton.addTarget(nil, action: #selector(tapSendButton(_:)), for: .touchUpInside)
        view = chatRoomView
        
        bind()
        configureDataSource()
    }
    
    private func bind() {
        viewModel.chattingsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] messages in
                guard let self else { return }
                
                var snapshot = NSDiffableDataSourceSnapshot<Section, Model.GPTMessage>()
                snapshot.appendSections([.main])
                snapshot.appendItems(messages)
                self.chattingDataSource.apply(snapshot)
                
                if !messages.isEmpty {
                    let indexPath = IndexPath(item: messages.count - 1, section: 0)
                    self.chatRoomView.chatCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
                }
            }
            .store(in: &cancellables)
    }
    
    private func configureDataSource() {
        chattingDataSource = UICollectionViewDiffableDataSource<Section, Model.GPTMessage>(
            collectionView: chatRoomView.chatCollectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                collectionView.dequeueConfiguredReusableCell(using: self.cellResistration, for: indexPath, item: itemIdentifier)
            }
        )
    }
    
    @objc
    private func tapSendButton(_ sender: Any) {
        if let content = chatRoomView.commentTextField.text, !content.isEmpty {
            viewModel.sendComment(Model.UserMessage(content: content))
        }
        chatRoomView.commentTextField.text = nil
    }
}

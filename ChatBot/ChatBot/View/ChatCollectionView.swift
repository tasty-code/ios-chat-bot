//
//  ChatCollectionView.swift
//  ChatBot
//
//  Created by 최승범 on 2024/01/12.
//

import UIKit

final class ChatCollectionView: UICollectionView {
    
    private enum Section {
        case main
    }
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, Message>?
    private var chatRecord: [Message] = []
    weak var chatServiceDelegate: ChatServiceDelegate?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("ChatCollectionView error")
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ChatBallonCell, Message> { (cell, indexPath, itemIdentifier) in
            
            guard let text = itemIdentifier.content else { return }
            
            cell.setLabelText(text: text)
            cell.setNeedsUpdateConfiguration()
        }
        
        diffableDataSource = UICollectionViewDiffableDataSource<Section, Message>(collectionView: self, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        saveSnapshot()
    }
    
    func saveSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Message>()
        snapshot.appendSections([.main])
        snapshot.appendItems(chatRecord)
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension ChatCollectionView: ChatCollectionViewDelegate {
    
    func addChatRecord(text: String) {
        chatRecord.append(Message(role: .user, content: text))
        saveSnapshot()
    }
    
    func updateCollectionViewFromResponse() async {
        let injectedDelegate = chatServiceDelegate?.injectChatServiceDelegate()
        do {
            guard let chatAnswer: ResponseModel = try await injectedDelegate?.getRequestData(inputData: RequestModel(messages: chatRecord)) else { return }
            chatRecord.append(chatAnswer.choices[0].message)
            saveSnapshot()
        }
        catch {
            print(error)
        }
    }
}

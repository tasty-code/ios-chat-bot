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
        let cellRegistration = UICollectionView.CellRegistration<ChatBalloonCell, Message> { (cell, indexPath, itemIdentifier) in
            
            guard let text = itemIdentifier.content else { return }
            cell.setLabelText(text: text)
       
            if itemIdentifier.role == .user {
                cell.setDirection(direction: .right)
            } else {
                cell.setDirection(direction: .left)
            }
        
        }
        
        diffableDataSource = UICollectionViewDiffableDataSource<Section, Message>(collectionView: self, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Message>()
        snapshot.appendSections([.main])
        
        self.diffableDataSource?.apply(snapshot)
        

    }
    
    func saveSnapshot() {
        guard var snapshot = diffableDataSource?.snapshot(), !chatRecord.isEmpty else { return }
        guard let data = chatRecord.last else { return }
        
        snapshot.appendItems([data], toSection: .main)
        diffableDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func removeSnapshot(replaceData: Message) {
        guard var snapshot = diffableDataSource?.snapshot(), !chatRecord.isEmpty else { return }
        guard let data = chatRecord.last else { return }

        snapshot.deleteItems([data])

        snapshot.appendItems([replaceData],toSection: .main)
        diffableDataSource?.apply(snapshot, animatingDifferences: true)
    }
}

extension ChatCollectionView: ChatCollectionViewDelegate {
    func addChatRecord(text: String) {
        chatRecord.append(Message(role: .user, content: text))
        saveSnapshot()
        
        chatRecord.append(Message(role: .assistant, content: ""))
        saveSnapshot()
        self.scrollToItem(at: IndexPath(row: self.numberOfItems(inSection: 0) - 1, section: 0),
                          at: .bottom,
                          animated: true)
    }
    
    func updateCollectionViewFromResponse() async {
        let injectedDelegate = chatServiceDelegate?.injectChatServiceDelegate()
        do {
            guard let chatAnswer: ResponseModel = try await injectedDelegate?.getRequestData(inputData: RequestModel(messages: chatRecord)) else { return }
            removeSnapshot(replaceData: chatAnswer.choices[0].message)
            
            self.scrollToItem(at: IndexPath(row: self.numberOfItems(inSection: 0) - 1, section: 0),
                              at: .bottom,
                              animated: true)
        }
        catch {
            print(error)
        }
    }
}

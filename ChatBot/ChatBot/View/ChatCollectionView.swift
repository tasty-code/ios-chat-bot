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
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, UUID>?
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
        let cellRegistration = UICollectionView.CellRegistration<ChatBalloonCell, UUID> { (cell, indexPath, itemIdentifier) in
            
            var message = [UUID: Message]()
            let tupleArray = self.chatRecord.map { ($0.id, $0) }
            message = Dictionary(uniqueKeysWithValues: tupleArray)
            
            guard let message = message[itemIdentifier],
                  let content = message.content
            else { return }
            cell.setLabelText(text: content)
            
            if message.role == .user {
                cell.setDirection(direction: .right)
            } else {
                cell.setDirection(direction: .left)
            }
        }
        
        diffableDataSource = UICollectionViewDiffableDataSource<Section, UUID>(collectionView: self, cellProvider: { collectionView, indexPath, uuid in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: uuid)
        })
        
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, UUID>()
        snapshot.appendSections([.main])
        self.diffableDataSource?.apply(snapshot)
    }
    
    private func saveSnapshot() {
        guard var snapshot = diffableDataSource?.snapshot(), !chatRecord.isEmpty else { return }
        guard let data = chatRecord.last else { return }
        
        snapshot.appendItems([data.id], toSection: .main)
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func removeSnapshot() {
        guard var snapshot = diffableDataSource?.snapshot(), !chatRecord.isEmpty else { return }
        guard let data = chatRecord.last else { return }
        
        snapshot.reconfigureItems([data.id])
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
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
            chatRecord[chatRecord.count-1].content = chatAnswer.choices[0].message.content
            removeSnapshot()
            
            self.scrollToItem(at: IndexPath(row: self.numberOfItems(inSection: 0) - 1, section: 0),
                              at: .bottom,
                              animated: true)
        }
        catch {
            print(error)
        }
    }
}

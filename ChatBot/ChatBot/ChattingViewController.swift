//
//  ChattingViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit

// MARK: - typealias

extension ChattingViewController {
    private typealias CellRegistration = UICollectionView.CellRegistration<ChatBalloonCell, UUID>
    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, UUID>
}

// MARK: - ViewController

final class ChattingViewController: UIViewController {
   
    private var diffableDataSource: DiffableDataSource?
    private var chatRecord: [Message] = []
    
    private let chatService: OpenAIServiceProtocol = ChatService(url: OpenAIURL(path: .chat), httpMethod: .post, contentType: .json)
    
    private let chatTextInputView = ChatTextInputView()
    private let collectionView: UICollectionView = {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsSelection = false
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        chatTextInputViewConfigure()
        collectionViewConfigure()
    }
    
    // MARK: -  initial configure setting

    private func chatTextInputViewConfigure() {
        chatTextInputView.delegate = self

        view.addSubview(chatTextInputView)

        NSLayoutConstraint.activate([
            chatTextInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            chatTextInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            chatTextInputView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -8)
        ])
    }
    
    private func collectionViewConfigure() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: chatTextInputView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        configureDataSource()
    }
    
    private func configureDataSource() {
        let cellRegistration = CellRegistration { (cell, indexPath, itemIdentifier) in
            
            let tupleArray = self.chatRecord.map { ($0.id, $0) }
            let chatRecordDictionary: [UUID: Message] = Dictionary(uniqueKeysWithValues: tupleArray)
            
            guard let message = chatRecordDictionary[itemIdentifier],
                  let content = message.content else { return }
            
            cell.setLabelText(text: content)

            if message.role == .user {
                cell.setDirection(direction: .right)
            } else {
                cell.setDirection(direction: .left)
            }
        }
        
        diffableDataSource = DiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, uuid in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: uuid)
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, UUID>()
        snapshot.appendSections([.main])
        self.diffableDataSource?.apply(snapshot)
    }
}

// MARK: - DiffableDataSource 관련 메소드

extension ChattingViewController {
    private enum Section {
        case main
    }

    private func saveSnapshot() {
        guard var snapshot = diffableDataSource?.snapshot(), !chatRecord.isEmpty else { return }
        guard let data = chatRecord.last else { return }
        
        snapshot.appendItems([data.id], toSection: .main)
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }

    private func replaceSnapShot() {
        guard var snapshot = diffableDataSource?.snapshot(), !chatRecord.isEmpty else { return }
        guard let data = chatRecord.last else { return }
        
        snapshot.reconfigureItems([data.id])
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension ChattingViewController: ChatCollectionViewDelegate {
    func addChatRecord(text: String) {
        chatRecord.append(Message(role: .user, content: text))
        saveSnapshot()
        
        chatRecord.append(Message(role: .assistant, content: ""))
        saveSnapshot()
        
        collectionView.scrollToItem(at: IndexPath(row: collectionView.numberOfItems(inSection: 0) - 1, section: 0),
                          at: .bottom,
                          animated: false)
    }
    
    func updateCollectionViewFromResponse() async {
        do {
            guard let chatAnswer: ResponseModel = try await chatService.sendRequestDTO(inputData: RequestModel(messages: chatRecord)) else { return }

            chatRecord[chatRecord.count-1].content = chatAnswer.choices[0].message.content
            replaceSnapShot()
            
            collectionView.scrollToItem(at: IndexPath(row: collectionView.numberOfItems(inSection: 0) - 1, section: 0),
                              at: .bottom,
                              animated: false)
        } catch {
            print(error)
        }
    }
}

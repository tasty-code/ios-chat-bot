//
//  GPTChatListViewController.swift
//  ChatBot
//
//  Created by BOMBSGIE on 1/23/24.
//

import UIKit

final class GPTChatListViewController: UIViewController {
    
    // MARK: - Nested Type
    
    private enum Section {
        case main
    }
    
    struct Mock: Hashable {
        var content: String
    }
    
    // MARK: - UI Components
    
    private lazy var chatListCollectionView: UICollectionView = {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, Mock> = {
        return UICollectionView.CellRegistration<UICollectionViewListCell, Mock> { cell, indexPath, itemIdentifier in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = itemIdentifier.content
            configuration.secondaryText = "날짜"
            configuration.secondaryTextProperties.color = .systemGray5
            cell.contentConfiguration = configuration
        }
    }()
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Mock> = {
        return UICollectionViewDiffableDataSource<Section, Mock>(collectionView: chatListCollectionView) { 
            collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: itemIdentifier)
        }
    }()
    
    private let navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "MyChatBot 🤖"
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .systemCyan
        return label
    }()
    
    private lazy var newChatBarButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "square.and.pencil")
        button.setImage(image, for: .normal)
        button.tintColor = .systemCyan
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Auto Layout

    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(chatListCollectionView)
        
        setConstraintsCollectionView()
        configureNavigationBarItem()
    }
    
    private func setConstraintsCollectionView() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            chatListCollectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            chatListCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            chatListCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            chatListCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    // MARK: - Navigation Bar
    
    private func configureNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationTitleLabel)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: newChatBarButton)
    }
}

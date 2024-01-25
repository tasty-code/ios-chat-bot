//
//  GPTRoomListViewController.swift
//  ChatBot
//
//  Created by BOMBSGIE on 1/23/24.
//

import UIKit

final class GPTRoomListViewController: UIViewController {
    
    // MARK: - Nested Type
    
    private enum Section {
        case main
    }

    // MARK: - UI Components
    
    private lazy var chatListCollectionView: UICollectionView = {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, ChatRoom> = {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ChatRoom> { cell, indexPath, itemIdentifier in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = itemIdentifier.title
            configuration.secondaryText = itemIdentifier.date.toString
            configuration.secondaryTextProperties.color = .systemGray5
            cell.contentConfiguration = configuration
        }
        return UICollectionViewDiffableDataSource<Section, ChatRoom>(collectionView: chatListCollectionView) {
            collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
    }()
    
    private let navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "MyChatBot 🤖"
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .systemCyan
        return label
    }()
    
    
    // MARK: - Private Property
    
    private let viewModel: GPTRoomListViewModel
    
    // MARK: - Initializer
    
    init(viewModel: GPTRoomListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        viewModel.didRoomAppend = { [weak self] roomList in
            guard let self else { return }
            configureSnapshot(with: roomList)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchRoomList()
    }
    
    // MARK: - Auto Layout

    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(chatListCollectionView)
        
        chatListCollectionView.delegate = self
        
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
        
        let image = UIImage(systemName: "square.and.pencil")
        let newChatButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(newChatButtonTapped(_:)))
        newChatButton.tintColor = .systemCyan
        self.navigationItem.rightBarButtonItem = newChatButton
    }
    
    // MARK: - Private Method
    
    private func configureSnapshot(with roomList: [ChatRoom]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ChatRoom>()
        snapshot.appendSections([.main])
        snapshot.appendItems(roomList)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - ActionHandler

    @objc
    private func newChatButtonTapped(_ sender: UIButton) {
        enterRoom()
    }
    
    private func enterRoom(with chatRoom: ChatRoom? = nil) {
        let networkManager = NetworkManager()
        let serviceProvider = ServiceProvider(networkManager: networkManager)
        let gptChatViewModel = GPTChatViewModel(serviceProvider: serviceProvider, currentRoom: chatRoom)
        let gptChatViewController = GPTChatViewController(viewModel: gptChatViewModel)
        navigationController?.pushViewController(gptChatViewController, animated: true)
    }
}

extension GPTRoomListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chatRoom = viewModel.getChatRoom(at: indexPath.row)
        enterRoom(with: chatRoom)
    }
}

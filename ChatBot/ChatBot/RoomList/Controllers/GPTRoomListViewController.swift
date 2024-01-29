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
    
    // MARK: - Typealias
    
    private typealias CellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ChatRoom>
    private typealias RoomDataSource = UICollectionViewDiffableDataSource<Section, ChatRoom>
    private typealias RoomSnapshot = NSDiffableDataSourceSnapshot<Section, ChatRoom>

    // MARK: - UI Components
    
    private lazy var roomListCollectionView: UICollectionView = {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.trailingSwipeActionsConfigurationProvider = configureSwipeActions(for:)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
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
    
    private lazy var dataSource: RoomDataSource = {
        let cellRegistration = CellRegistration { cell, indexPath, itemIdentifier in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = itemIdentifier.title
            configuration.secondaryText = itemIdentifier.date.toString
            configuration.secondaryTextProperties.color = .systemGray
            
            cell.contentConfiguration = configuration
        }
        return RoomDataSource(collectionView: roomListCollectionView) { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
    }()
    
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
        view.addSubview(roomListCollectionView)
        
        roomListCollectionView.delegate = self
        
        setConstraintsCollectionView()
        configureNavigationBarItem()
    }
    
    private func setConstraintsCollectionView() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            roomListCollectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            roomListCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            roomListCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            roomListCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
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
    
    // MARK: - Snapshot
    
    private func configureSnapshot(with roomList: [ChatRoom]) {
        var snapshot = RoomSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(roomList)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - Action Handler

    @objc
    private func newChatButtonTapped(_ sender: UIButton) {
        enterRoom()
    }
    
    private func configureSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath = indexPath
        else {
            return nil
        }
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") {
            [weak self] _, _, completion in
            self?.viewModel.deleteChatRoom(at: indexPath.row)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func enterRoom(with chatRoom: ChatRoom? = nil) {
        let networkManager = NetworkManager()
        let serviceProvider = ServiceProvider(networkManager: networkManager)
        let dataHandler = MessageDataHandler()
        let gptChatViewModel = GPTChatViewModel(
            serviceProvider: serviceProvider,
            dataHandler: dataHandler,
            currentRoom: chatRoom)
        let gptChatViewController = GPTChatViewController(viewModel: gptChatViewModel)
        navigationController?.pushViewController(gptChatViewController, animated: true)
    }
}

// MARK: - UICollectionViewDelegate

extension GPTRoomListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chatRoom = viewModel.getChatRoom(at: indexPath.row)
        enterRoom(with: chatRoom)
    }
}

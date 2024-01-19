//
//  GPTChatRoomsViewController.swift
//  ChatBot
//
//  Created by 김준성 on 1/19/24.
//

import Combine
import UIKit

class GPTChatRoomsViewController: UIViewController {
    enum Section {
        case main
    }
    
    private let viewModel: any GPTChatRoomsVMProtocol
    private let fetchRoomsSubject = PassthroughSubject<Void, Never>()
    private let createRoomSubject = PassthroughSubject<String, Never>()
    private let modifyRoomSubject = PassthroughSubject<(Model.GPTChatRoomDTO, IndexPath), Never>()
    private let deleteRoomSubject = PassthroughSubject<(Model.GPTChatRoomDTO, IndexPath), Never>()
    private let selectRoomSubject = PassthroughSubject<(Model.GPTChatRoomDTO, IndexPath), Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var tableView = {
        let tableView = UITableView(frame: .infinite, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "GPTChatRoomCell")
        return tableView
    }()
    
    private var chatRoomsDataSource: UITableViewDiffableDataSource<Section, Model.GPTChatRoomDTO>!
    
    init(viewModel: any GPTChatRoomsVMProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureDataSource()
        bind(to: viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRoomsSubject.send()
    }
    
    private func bind(to viewModel: any GPTChatRoomsVMProtocol) {
        let input = GPTChatRoomsInput(
            fetchRooms: fetchRoomsSubject.eraseToAnyPublisher(),
            createRoom: createRoomSubject.eraseToAnyPublisher(),
            modifyRoom: modifyRoomSubject.eraseToAnyPublisher(),
            deleteRoom: deleteRoomSubject.eraseToAnyPublisher(),
            selectRoom: selectRoomSubject.eraseToAnyPublisher()
        )
        
        viewModel.transform(from: input)
            .sink { [weak self] output in
                switch output {
                case .success(let rooms):
                    self?.applySnapshot(rooms: rooms)
                case .failure(let error):
                    print(error)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Configure UI
extension GPTChatRoomsViewController {
    private func configureUI() {
        navigationItem.title = "MyChatBot 🤖"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(createChatRoomButtonTapped(_:)))
    }
}

// MARK: - Confiure TableView
extension GPTChatRoomsViewController {
    private func configureDataSource() {
        self.chatRoomsDataSource = ChatRoomDataSource(
            tableView: tableView,
            deleteRoomSubject: deleteRoomSubject
        ) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "GPTChatRoomCell", for: indexPath)
            var config = cell.defaultContentConfiguration()
            config.text = itemIdentifier.title
            config.secondaryText = itemIdentifier.recentChatDate.description
            cell.contentConfiguration = config
            return cell
        }
    }
    
    private func applySnapshot(rooms: [Model.GPTChatRoomDTO]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Model.GPTChatRoomDTO>()
        snapshot.appendSections([.main])
        snapshot.appendItems(rooms)
        chatRoomsDataSource.apply(snapshot)
    }
}

extension GPTChatRoomsViewController {
    @objc
    private func createChatRoomButtonTapped(_ Sender: Any) {
        createRoomSubject.send("하이 하이 요요요")
    }
}

//
//  GPTChatRoomsViewController.swift
//  ChatBot
//
//  Created by 김준성 on 1/19/24.
//

import Combine
import UIKit

final class GPTChatRoomsViewController: UIViewController {
    enum Section {
        case main
    }
    
    private let viewModel: any GPTChatRoomsVMProtocol
    private let fetchRoomsSubject = PassthroughSubject<Void, Never>()
    private let createRoomSubject = PassthroughSubject<String, Never>()
    private let modifyRoomSubject = PassthroughSubject<(IndexPath, String), Never>()
    private let deleteRoomSubject = PassthroughSubject<IndexPath, Never>()
    private let selectRoomSubject = PassthroughSubject<IndexPath, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var tableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "GPTChatRoomCell")
        tableView.delegate = self
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
    
    //    override func loadView() {
    //        view = tableView
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureDataSource()
        bind(to: viewModel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
                case .moveToChatRoom(let chatRoomViewModel):
                    let viewController = GPTChattingViewController(viewModel: chatRoomViewModel)
                    self?.navigationController?.pushViewController(viewController, animated: true)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Configure UI
extension GPTChatRoomsViewController {
    private func configureUI() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: tableView.topAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
        ])
        
        navigationItem.title = "MyChatBot 🤖"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(createChatRoomButtonTapped(_:)))
    }
}

// MARK: - Confiure TableView
extension GPTChatRoomsViewController {
    private func configureDataSource() {
        self.chatRoomsDataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
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
        present(configureCreateRoomAlert(), animated: true)
    }
}

extension GPTChatRoomsViewController {
    private func configureCreateRoomAlert() -> UIAlertController {
        let alertController = UIAlertController(title: "채팅방 생성", message: "방 제목을 입력해주세요.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "생성", style: .default) { [unowned self] _ in
            guard let roomName = alertController.textFields?.first?.text else {
                return
            }
            createRoomSubject.send(roomName)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .destructive)
        
        alertController.addTextField { textField in
            textField.placeholder = "제목 입력"
            textField.translatesAutoresizingMaskIntoConstraints = false
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        return alertController
    }
    
    private func configureModifyRoomAlert(for indexPath: IndexPath) -> UIAlertController {
        let alertController = UIAlertController(title: "방 제목 수정", message: "방 제목을 입력해주세요.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "수정", style: .default) { [unowned self] _ in
            guard let roomName = alertController.textFields?.first?.text else {
                return
            }
            modifyRoomSubject.send((indexPath, roomName))
        }
        let cancelAction = UIAlertAction(title: "취소", style: .destructive)
        
        alertController.addTextField { textField in
            textField.placeholder = "제목 입력"
            textField.translatesAutoresizingMaskIntoConstraints = false
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        return alertController
    }
}

extension GPTChatRoomsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectRoomSubject.send(indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modifyAction = UIContextualAction(style: .normal, title: "수정", handler: { [unowned self] (action, view, completionHandler) in
            present(configureModifyRoomAlert(for: indexPath), animated: true)
            completionHandler(true)
        })
        modifyAction.backgroundColor = .systemOrange
        
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제", handler: { [unowned self] (action, view, completionHandler) in
            deleteRoomSubject.send(indexPath)
            completionHandler(true)
        })
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction, modifyAction])
    }
}

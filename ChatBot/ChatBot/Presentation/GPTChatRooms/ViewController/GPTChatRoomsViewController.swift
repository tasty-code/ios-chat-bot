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
    
    enum Row: Hashable {
        case forMain(title: String, localeDateString: String)
    }
    
    private let viewModel: any GPTChatRoomsVMProtocol
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var tableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "GPTChatRoomCell")
        tableView.delegate = self
        return tableView
    }()
    
    private var chatRoomsDataSource: UITableViewDiffableDataSource<Section, Row>!
    
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
        viewModel.onViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.onViewWillAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.onViewDidDisappear()
    }
    
    private func bind(to viewModel: any GPTChatRoomsVMProtocol) {
        Publishers.Zip(viewModel.moveToChatting, viewModel.moveToPromptSetting)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (chattingViewModel, promptSettingViewModel) in
                let chattingVC = GPTChattingViewController(viewModel: chattingViewModel)
                let promptSettingVC = GPTPromptSettingViewController(viewModel: promptSettingViewModel)
                guard let tabbarVC = self?.configureTabbarController(chattingVC, promptSettingVC) else { return }
                
                self?.navigationController?.pushViewController(tabbarVC, animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.updateChatRooms
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] chatRooms in
                self?.handleUpdateChatRooms(chatRooms)
            })
            .store(in: &cancellables)
        
        viewModel.error
            .flatMap { UIAlertController.presentErrorPublisher(on: self, with: $0) }
            .sink { _ in }
            .store(in: &cancellables)
    }
    
    private func handleUpdateChatRooms(_ chatRooms: [Model.GPTChatRoomDTO]) {
        applySnapshot(sectionRows: chatRooms.map { Row.forMain(title: $0.title, localeDateString: $0.recentChatDate.toLocaleString(.koKR)) })
    }
}

// MARK: - Configure UI
extension GPTChatRoomsViewController {
    private func configureUI() {
        navigationItem.title = "MyChatBot 🤖"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(createChatRoomButtonTapped(_:)))
    }
    
    private func configureCreateRoomAlert() -> UIAlertController {
        UIAlertController(title: "방 생성", message: "생성할 방 제목을 입력해주세요.") { [weak self] roomName in
            self?.viewModel.createRoom(roomName)
        }
    }
    
    private func configureModifyRoomAlert(for indexPath: IndexPath) -> UIAlertController {
        UIAlertController(title: "방 수정", message: "수정할 방 제목을 입력해주세요.") { [weak self] roomName in
            self?.viewModel.modifyRoom(roomName, for: indexPath)
        }
    }
    
    private func configureTabbarController(_ chattingVC: GPTChattingViewController, _ promptSettingVC: GPTPromptSettingViewController) -> UITabBarController {
        let tabbarController = UITabBarController()
        tabbarController.setViewControllers([chattingVC, promptSettingVC], animated: true)
        if let items = tabbarController.tabBar.items {
            items[0].selectedImage = UIImage(systemName: "folder.fill")
            items[0].image = UIImage(systemName: "folder")
            items[0].title = "채팅"
            
            items[1].selectedImage = UIImage(systemName: "folder.fill")
            items[1].image = UIImage(systemName: "folder")
            items[1].title = "프롬프트"
        }
        return tabbarController
    }
}

// MARK: - Confiure TableView
extension GPTChatRoomsViewController {
    private func configureDataSource() {
        self.chatRoomsDataSource = UITableViewDiffableDataSource(tableView: tableView) { [weak self] tableView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case.forMain(let title, let localeDateString):
                self?.configureMainCell(for: indexPath, title: title, localeDateString: localeDateString)
            }
        }
    }
    
    private func applySnapshot(sectionRows: [Row]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Row>()
        snapshot.appendSections([.main])
        snapshot.appendItems(sectionRows)
        chatRoomsDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func configureMainCell(for indexPath: IndexPath, title: String, localeDateString: String) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GPTChatRoomCell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = title
        config.secondaryText = localeDateString
        cell.contentConfiguration = config
        return cell
    }
}

// MARK: - set UIRespond
extension GPTChatRoomsViewController {
    @objc
    private func createChatRoomButtonTapped(_ Sender: Any) {
        present(configureCreateRoomAlert(), animated: true)
    }
}

// MARK: - UITableViewDelegate
extension GPTChatRoomsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectRoom(for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modifyAction = UIContextualAction(style: .normal, title: "수정", handler: { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            present(configureModifyRoomAlert(for: indexPath), animated: true)
            completionHandler(true)
        })
        modifyAction.backgroundColor = .systemOrange
        
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제", handler: { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            viewModel.deleteRoom(for: indexPath)
            completionHandler(true)
        })
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction, modifyAction])
    }
}

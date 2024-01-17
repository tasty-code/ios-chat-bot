//
//  ViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit
import Combine

final class GPTChatRoomViewController: UIViewController {
    enum Section {
        case main
    }
    
    private lazy var chatCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(GPTChatRoomCell.self, forCellWithReuseIdentifier: "\(type(of: GPTChatRoomCell.self))")
        return collectionView
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
         stackView.axis = .horizontal
         stackView.translatesAutoresizingMaskIntoConstraints = false
         stackView.distribution = .fill
         stackView.addArrangedSubview(commentTextView)
         stackView.addArrangedSubview(sendButton)
         return stackView
     }()
    
    private lazy var commentTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.layer.cornerRadius = ((textView.font?.pointSize ?? 24) / 2)
        textView.backgroundColor = .white
        textView.textColor = .black
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textView
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 32)
        let uiImage = UIImage(systemName: "arrow.up.circle.fill", withConfiguration: imageConfiguration)
        button.setImage(uiImage, for: .normal)
        button.contentMode = .scaleToFill
        button.addTarget(nil, action: #selector(tapSendButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private let viewModel: GPTChatRoomVMProtocol
    private let cellResistration = UICollectionView.CellRegistration<GPTChatRoomCell, Model.GPTMessage> { cell, indexPath, itemIdentifier in
        cell.configureCell(to: itemIdentifier)
    }
    
    private var chattingDataSource: UICollectionViewDiffableDataSource<Section, Model.GPTMessage>!
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: GPTChatRoomVMProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
        bind()
        configureDataSource()
    }
    
    private func bind() {
        viewModel.chattingsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] messages in
                guard let self else { return }
                
                var snapshot = NSDiffableDataSourceSnapshot<Section, Model.GPTMessage>()
                snapshot.appendSections([.main])
                snapshot.appendItems(messages)
                self.chattingDataSource.apply(snapshot)
                
                if !messages.isEmpty {
                    let indexPath = IndexPath(item: messages.count - 1, section: 0)
                    chatCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
                }
            }
            .store(in: &cancellables)
        
        viewModel.lastestUpdateIndexSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                guard let self else { return }
                
                let indexPath = IndexPath(item: index, section: 0)
                chatCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.errorMessageSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self else { return }
                present(configureErrorAlert(error), animated: true)
            }
            .store(in: &cancellables)
    }
}

// MARK: - set Views
extension GPTChatRoomViewController {
    private func configureUI() {
        view.addSubview(chatCollectionView)
        view.addSubview(horizontalStackView)
        
        NSLayoutConstraint.activate([
            chatCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chatCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            chatCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            chatCollectionView.bottomAnchor.constraint(equalTo: horizontalStackView.topAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 4),
            horizontalStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -4),
            horizontalStackView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -4)
        ])
    }
}

// MARK: - configure Collection View
extension GPTChatRoomViewController {
    private func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - configure Diffable Data Source
extension GPTChatRoomViewController {
    private func configureDataSource() {
        chattingDataSource = UICollectionViewDiffableDataSource<Section, Model.GPTMessage>(
            collectionView: chatCollectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                collectionView.dequeueConfiguredReusableCell(using: self.cellResistration, for: indexPath, item: itemIdentifier)
            }
        )
    }
}

 // MARK: - set UIRespond
extension GPTChatRoomViewController {
    @objc
    private func tapSendButton(_ sender: Any) {
        viewModel.sendComment(commentTextView.text)
        commentTextView.text = nil
    }
}

// MARK: - configure AlertController
extension GPTChatRoomViewController {
    private func configureErrorAlert(_ error: Error) -> UIAlertController {
        let alert = UIAlertController(title: "\(type(of: error))", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        return alert
    }
}

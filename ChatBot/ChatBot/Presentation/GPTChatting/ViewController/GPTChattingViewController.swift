//
//  GPTChattingViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit
import Combine

final class GPTChattingViewController: UIViewController {
    enum Section {
        case main
    }
    
    private lazy var chatCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(GPTChattingCell.self, forCellWithReuseIdentifier: "\(type(of: GPTChattingCell.self))")
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
    
    private let fetchChattingsSubject = PassthroughSubject<Void, Never>()
    private let sendCommentSubject = PassthroughSubject<String?, Never>()
    private let storeChattingsSubject = PassthroughSubject<Void, Never>()
    
    private let viewModel: any GPTChattingVMProtocol
    private let cellResistration = UICollectionView.CellRegistration<GPTChattingCell, Model.GPTMessage> { cell, indexPath, itemIdentifier in
        cell.configureCell(to: itemIdentifier)
    }
    
    private var chattingDataSource: UICollectionViewDiffableDataSource<Section, Model.GPTMessage>!
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: any GPTChattingVMProtocol) {
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
        bind(to: viewModel)
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchChattingsSubject.send()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        storeChattingsSubject.send()
    }
    
    private func bind(to viewModel: any GPTChattingVMProtocol) {
        let input = GPTChatRoomInput(
            fetchChattings: fetchChattingsSubject.eraseToAnyPublisher(),
            sendComment: sendCommentSubject.eraseToAnyPublisher(),
            storeChattings: storeChattingsSubject.eraseToAnyPublisher()
        )
        let output = viewModel.transform(from: input)
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
            guard let self = self else { return }
                
            switch output {
            case .success(let replies, let indexToUpdate):
                self.updateCollectionView(replies, indexToUpdate: indexToUpdate)
            case .failure(let error):
                self.present(UIAlertController(error: error), animated: true)
            }
        }
        .store(in: &cancellables)
    }
}

// MARK: - set Views
extension GPTChattingViewController {
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
extension GPTChattingViewController {
    private func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func updateCollectionView(_ updatedMessages: [Model.GPTMessage], indexToUpdate: Int) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Model.GPTMessage>()
        snapshot.appendSections([.main])
        snapshot.appendItems(updatedMessages)
        chattingDataSource.apply(snapshot)
        
        chatCollectionView.scrollToItem(at: IndexPath(row: indexToUpdate, section: 0), at: .top, animated: true)
    }
}

// MARK: - configure Diffable Data Source
extension GPTChattingViewController {
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
extension GPTChattingViewController {
    @objc
    private func tapSendButton(_ sender: Any) {
        sendCommentSubject.send(commentTextView.text)
        commentTextView.text = nil
    }
}

//
//  GPTChatViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit

final class GPTChatViewController: UIViewController {
    
    // MARK: - NestedType
    
    private enum Section {
        case main
    }
    
    // MARK: - Typealias
    
    private typealias CellRegistration = UICollectionView.CellRegistration<MessageCell, ChatMessage>
    private typealias ChatDataSource = UICollectionViewDiffableDataSource<Section, ChatMessage>
    private typealias ChatSnapshot = NSDiffableDataSourceSnapshot<Section, ChatMessage>
    
    // MARK: - UI Components
    
    private lazy var chatCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        collectionView.allowsSelection = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    
    private let userInputTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 20
        textView.layer.borderWidth = 3.0
        textView.layer.borderColor = UIColor.systemGray6.cgColor
        textView.font = .preferredFont(forTextStyle: .body)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.isScrollEnabled = false
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 40)
        let buttonImage = UIImage(systemName: "arrow.up.circle.fill", withConfiguration: imageConfiguration)
        button.setImage(buttonImage, for: .normal)
        button.contentMode = .scaleToFill
        button.tintColor = .systemCyan
        button.addTarget(self, action: #selector(sendButtonTapped(_:)), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var userInteractionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.addArrangedSubview(userInputTextView)
        stackView.addArrangedSubview(sendButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Private Property
    
    private let viewModel: GPTChatViewModel
    
    private lazy var dataSource: ChatDataSource = {
        let cellRegistration = CellRegistration { cell, indexPath, item in
            var configuration = MessageContentConfiguration()
            configuration.message = item
            cell.contentConfiguration = configuration
        }
        return ChatDataSource(collectionView: chatCollectionView) { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
    }()
    
    // MARK: - Initializer
    
    init(viewModel: GPTChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        viewModel.didMessagesAppend = { [weak self] messages in
            guard let self else { return }
            configureSnapshot(with: messages)
            updateUI()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchMessages()
    }
    
    // MARK: - Auto Layout
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(chatCollectionView)
        view.addSubview(userInteractionStackView)
        
        userInputTextView.delegate = self
        
        setConstraintsCollectionView()
        setConstraintsStackView()
        setConstraintsTextView()
    }
    
    private func setConstraintsCollectionView() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            chatCollectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            chatCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            chatCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
        ])
    }
    
    private func setConstraintsStackView() {
        NSLayoutConstraint.activate([
            userInteractionStackView.topAnchor.constraint(equalTo: chatCollectionView.bottomAnchor, constant: 10),
            userInteractionStackView.leadingAnchor.constraint(equalTo: chatCollectionView.leadingAnchor),
            userInteractionStackView.trailingAnchor.constraint(equalTo: chatCollectionView.trailingAnchor),
            view.keyboardLayoutGuide.topAnchor
                .constraint(equalToSystemSpacingBelow: userInteractionStackView.bottomAnchor, multiplier: 1.0)
        ])
    }
    
    private func setConstraintsTextView() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            userInputTextView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.8),
            userInputTextView.heightAnchor.constraint(equalToConstant: userInputTextView.estimatedSizeHeight)
        ])
    }
    
    // MARK: - Configure CollectionView
    
    private func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .white
        
        let compositionalLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        return compositionalLayout
    }
    
    private func configureSnapshot(with messages: [ChatMessage]) {
        var snapshot = ChatSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(messages)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - Action Handler
    
    @objc
    private func sendButtonTapped(_ sender: UIButton) {
        guard let userMessageText = userInputTextView.text,
              !userMessageText.isEmpty
        else {
            return
        }
        
        viewModel.fetch(userInput: userMessageText)
        
        userInputTextView.resignFirstResponder()
        userInputTextView.text = nil
        userInputTextView.insertText("")
        
        sender.isEnabled = false
    }
    
    private func updateUI() {
        scrollToLast()
        sendButton.isEnabled = true
    }
    
    private func scrollToLast() {
        let lastItemIndex = max(0, chatCollectionView.numberOfItems(inSection: 0) - 1)
        let indexPath = IndexPath(item: lastItemIndex, section: 0)
        chatCollectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
}

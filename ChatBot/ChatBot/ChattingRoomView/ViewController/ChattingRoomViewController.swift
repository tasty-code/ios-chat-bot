import UIKit

final class ChattingRoomViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    // MARK: Namespace
    enum Constants {
        static let buttonImageName: String = "paperplane.fill"
        static let defaultMargin: CGFloat = 6
        static let messageTextViewHeightRatio: CGFloat = 1/6
        static let messageBubbleWidthRatio: CGFloat = 2/3
    }
    
    // MARK: View Components
    private lazy var chattingRoomView: UICollectionView! = {
        let chattingRoomView = UICollectionView(frame: view.bounds, collectionViewLayout: configureLayout())
        chattingRoomView.translatesAutoresizingMaskIntoConstraints = false
        chattingRoomView.allowsSelection = false
        chattingRoomView.keyboardDismissMode = .onDrag
        return chattingRoomView
    }()
    
    private lazy var bottomStackView: UIStackView! = {
        let padding = Constants.defaultMargin
        let stackView = UIStackView(frame: view.bounds)
        stackView.addArrangedSubviews(messageTextView, messageSendButton)
        stackView.axis = .horizontal
        stackView.spacing = padding
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var messageTextView: UITextView! = {
        let textView = UITextView(frame: view.bounds)
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.backgroundColor = .secondarySystemBackground
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var messageSendButton: UIButton! = {
        var configuration = UIButton.Configuration.plain()
        configuration.cornerStyle = .capsule
        configuration.image = UIImage(systemName: Constants.buttonImageName)
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(touchUpMessageSendButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Properties
    private var dataSource: DataSource! = nil
    private var snapshot: Snapshot! = Snapshot()
    
    // MARK: Dependencies
    private let networkManager: NetworkRequestable!
    
    init(networkManager: NetworkRequestable) {
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) 구현되지 않음.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureHierarchy()
        configureConstraints()
        configureDataSource()
    }
}

// MARK: Private Methods
extension ChattingRoomViewController {
    @objc private func touchUpMessageSendButton() {
        guard messageTextView.hasText == true,
              let text = messageTextView.text
        else { return }
        
        submitMessage(role: .user, text: text)
        submitMessage(role: .assistant, text: "...")
        sendMessageToGPT()
        messageTextView.text = String()
    }
    
    private func submitMessage(role: Role, text: String) {
        let message = Message(role: role, content: text)
        updateDataSource(with: message)
    }
    
    private func prepareToSend(_ messages: [Message], to gptModel: GPTModel) -> NetworkRequestBuilderProtocol {
        let requestModel = RequestModel(model: gptModel, messages: messages, stream: false)
        let endpoint = EndpointType.chatCompletion(apiKey: Bundle.main.APIKey)
        let builder: NetworkRequestBuilderProtocol = NetworkRequestBuilder(jsonEncodeManager: JSONEncodeManager(), endpoint: endpoint)
        builder.setHttpHeaderFields(httpHeaderFields: endpoint.header)
        builder.setHttpMethod(httpMethod: .post)
        builder.setRequestModel(requestModel: requestModel)
        return builder
    }
    
    private func sendMessageToGPT() {
        let messages = snapshot.itemIdentifiers[0..<snapshot.numberOfItems - 1].map({ $0.message })
        let builder = prepareToSend(messages, to: .gpt_3_5_turbo)
        do {
            let request = try builder.build()
            Task {
                let responseModel = try await networkManager?.request(urlRequest: request)
                guard let newMessage = responseModel?.choices.first?.message else { return }
                reloadCurrentDataSource(with: newMessage)
            }
        } catch {
            let errorMessage = Message(role: .assistant, content: error.localizedDescription)
            reloadCurrentDataSource(with: errorMessage)
        }
    }
}

// MARK: ChattingRoomView Configuration Methods
extension ChattingRoomViewController {
    private func configureHierarchy() {
        view.addSubviews(chattingRoomView, bottomStackView)
    }
    
    private func configureLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<MessageCell, Message> { (cell, indexPath, item) in
            cell.message = item
        }
        
        dataSource = DataSource(collectionView: chattingRoomView) { (chattingRoomView, indexPath, itemIdentifier) -> MessageCell? in
            let cell = chattingRoomView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier.message)
            return cell
        }
        
        snapshot.appendSections(Section.allCases)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: DataSource Controls
extension ChattingRoomViewController {
    enum Section: CaseIterable {
        case main
    }
    
    private struct Item: Hashable {
        let id: String
        let message: Message
        
        init(id: String = UUID().uuidString, message: Message) {
            self.id = id
            self.message = message
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func == (lhs: ChattingRoomViewController.Item, rhs: ChattingRoomViewController.Item) -> Bool {
            return lhs.id == rhs.id
        }
    }
    
    private func updateDataSource(with messages: [Message?]) {
        let items: [Item] = messages.compactMap { message in
            guard let message = message else { return nil }
            return Item(message: message)
        }
        
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
        
        scrollToBottom(itemsCount: snapshot.numberOfItems, sectionsCount: snapshot.numberOfSections)
    }
    
    private func updateDataSource(with message: Message) {
        let item = Item(message: message)
        
        snapshot.appendItems([item])
        dataSource.apply(snapshot, animatingDifferences: true)
        
        scrollToBottom(itemsCount: snapshot.numberOfItems, sectionsCount: snapshot.numberOfSections)
    }
    
    private func reloadCurrentDataSource(with message: Message) {
        guard let lastItem = snapshot.itemIdentifiers.last else { return }
        let newItem = Item(message: message)
        snapshot.deleteItems([lastItem])
        snapshot.appendItems([newItem])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func scrollToBottom(itemsCount: Int, sectionsCount: Int, at position: UICollectionView.ScrollPosition = .bottom) {
        guard itemsCount > 0,
              sectionsCount > 0
        else { return }
        chattingRoomView.scrollToItem(at: IndexPath(item: itemsCount - 1, section: sectionsCount - 1), at: position, animated: true)
    }
}

// MARK: Autolayout Methods
extension ChattingRoomViewController {
    private func configureConstraints() {
        let layoutMargin = Constants.defaultMargin
        let messageTextViewHeightRatio = Constants.messageTextViewHeightRatio
        
        NSLayoutConstraint.activate([
            chattingRoomView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chattingRoomView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor),
            chattingRoomView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: layoutMargin),
            chattingRoomView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -layoutMargin)
        ])
        
        NSLayoutConstraint.activate([
            bottomStackView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            bottomStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: layoutMargin),
            bottomStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -layoutMargin),
            bottomStackView.heightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: messageTextViewHeightRatio)
        ])
        
        NSLayoutConstraint.activate([
            messageSendButton.heightAnchor.constraint(equalTo: bottomStackView.heightAnchor),
            messageSendButton.widthAnchor.constraint(equalTo: messageSendButton.heightAnchor)
        ])
    }
}

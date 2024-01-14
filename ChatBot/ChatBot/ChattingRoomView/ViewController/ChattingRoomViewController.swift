import UIKit

final class ChattingRoomViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item?>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item?>
    
    // MARK: Namespace
    enum Constants {
        static let buttonImageName: String = "arrow.up"
        static let defaultMargin: CGFloat = 6
        static let messageTextViewHeightRatio: CGFloat = 1/6
    }
    
    enum Section: CaseIterable {
        case main
    }
    
    private struct Item: Hashable {
        let id: String = UUID().uuidString
        let message: Message
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func == (lhs: ChattingRoomViewController.Item, rhs: ChattingRoomViewController.Item) -> Bool {
            return lhs.id == rhs.id
        }
    }
    
    // MARK: View Components
    private lazy var chattingRoomView: UICollectionView! = {
        let chattingRoomView = UICollectionView(frame: view.bounds, collectionViewLayout: configureLayout())
        chattingRoomView.translatesAutoresizingMaskIntoConstraints = false
        chattingRoomView.allowsSelection = false
        return chattingRoomView
    }()
    
    private lazy var bottomStackView: UIStackView! = {
        let padding = Constants.defaultMargin
        let stackView = UIStackView()
        stackView.addArrangedSubviews(messageTextView, messageSendButton)
        stackView.axis = .horizontal
        stackView.spacing = padding
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.layoutMargins = UIEdgeInsets(top: padding,
                                               left: padding,
                                               bottom: padding,
                                               right: padding)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var messageTextView: UITextView! = {
        let textView = UITextView()
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
    private var messages: [Message] {
        didSet {
            updateDataSource(with: messages)
        }
    }
    
    // MARK: Dependencies
    private let networkManager: NetworkRequestable!
    
    init(messages: [Message], networkManager: NetworkRequestable) {
        self.messages = messages
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
        
        submitMessage(text: text)
        let preparedMessages: [Message] = prepareMessages(text: text)
        sendMessage(messages: preparedMessages)
        messageTextView.text = String()
    }
    
    private func submitMessage(text: String) {
        let message = Message(role: .user, content: text)
        messages.append(message)
    }
    
    private func prepareMessages(text: String) -> [Message] {
        var messages: [Message] = []
        let newMessage: Message = Message(role: .user, content: text)
        let oldMessage: Message? = messages.last
        if let oldMessage = oldMessage { messages.append(oldMessage) }
        messages.append(newMessage)
        return messages
    }
    
    private func sendMessage(messages: [Message]) {
        let builder = prepareToSend(messages, to: .gpt_3_5_turbo)
        do {
            let request = try builder.build()
            Task {
                let responseModel = try await networkManager?.request(urlRequest: request)
                guard let newMessage = responseModel?.choices.first?.message else { return }
                self.messages.append(newMessage)
            }
        } catch {
            print(error)
        }
    }
    
    private func prepareToSend(_ messages: [Message], to gptModel: GPTModel) -> NetworkRequestBuilderProtocol {
        let requestModel = RequestModel(model: gptModel, messages: messages, stream: false)
        let endpoint = EndpointType.chatCompletion(apiKey: Bundle.main.APIKey)
        var builder: NetworkRequestBuilderProtocol = NetworkRequestBuilder(jsonEncodeManager: JSONEncodeManager(), endpoint: endpoint)
        builder.setHttpHeaderFields(httpHeaderFields: endpoint.header)
        builder.setHttpMethod(httpMethod: .post)
        builder.setRequestModel(requestModel: requestModel)
        return builder
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
            let margin = Constants.defaultMargin
            var configuration = cell.defaultContentConfiguration()
            configuration.directionalLayoutMargins = NSDirectionalEdgeInsets(top: margin,
                                                                             leading: margin,
                                                                             bottom: margin,
                                                                             trailing: margin)
            cell.contentConfiguration = configuration
            cell.configureCell(with: item)
        }
        
        dataSource = DataSource(collectionView: chattingRoomView) { (chattingRoomView, indexPath, itemIdentifier) -> UICollectionViewListCell? in
            let cell = chattingRoomView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier?.message)
            cell.configureCell(with: itemIdentifier?.message)
            return cell
        }
        
        updateDataSource(with: messages)
    }
    
    private func updateDataSource(with messages: [Message?]) {
        let items: [Item?] = messages.map({ message in
            guard let message = message else { return nil }
            return Item(message: message)
        })
        
        snapshot.deleteAllItems()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
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

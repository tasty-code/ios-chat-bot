import UIKit

final class ChattingRoomViewController: UIViewController {
    // MARK: Namespace
    enum Constants {
        static let textFieldPlaceholder: String = "문자 메세지"
        static let buttonImageName: String = "arrow.up"
        static let defaultMargin: CGFloat = 10
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
        stackView.addArrangedSubviews(textField, messageSendButton)
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
    
    private lazy var textField: UITextField! = {
        let textField = UITextField()
        textField.placeholder = Constants.textFieldPlaceholder
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var messageSendButton: UIButton! = {
        let button = UIButton()
        let image = UIImage(systemName: Constants.buttonImageName)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Properties
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
    private var messages: [Item]?
    
    init(messages: [Message]) {
        super.init(nibName: nil, bundle: nil)
        self.messages = messages.map({ Item(message: $0) })
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureHierarchy()
        configureConstraints()
        configureDataSource()
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
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Message> { (cell, indexPath, item) in
            let margin = item.role == .user ? cell.contentView.bounds.width / 3 : Constants.defaultMargin
            var configuration = cell.defaultContentConfiguration()
            configuration.directionalLayoutMargins = NSDirectionalEdgeInsets(top: Constants.defaultMargin,
                                                                             leading: margin,
                                                                             bottom: Constants.defaultMargin,
                                                                             trailing: Constants.defaultMargin)
            configuration.text = item.content
            configuration.textProperties.numberOfLines = .zero
            cell.contentConfiguration = configuration
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: chattingRoomView) { (chattingRoomView, indexPath, itemIdentifier) -> UICollectionViewListCell? in
            return chattingRoomView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier.message)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(messages ?? []) // ToDo: 보다 확실한 Assertion 방지 대책 필요
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: Autolayout Methods
extension ChattingRoomViewController {
    private func configureConstraints() {
        let layoutMargin = Constants.defaultMargin
        
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
        ])
        
        NSLayoutConstraint.activate([
            messageSendButton.heightAnchor.constraint(equalTo: bottomStackView.heightAnchor),
            messageSendButton.widthAnchor.constraint(equalTo: messageSendButton.heightAnchor)
        ])
    }
}

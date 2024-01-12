import UIKit

final class ChattingRoomViewController: UIViewController {
    // MARK: Namespace
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
    private var chattingRoomView: UICollectionView! = nil
    
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
        chattingRoomView = UICollectionView(frame: view.bounds, collectionViewLayout: configureLayout())
        chattingRoomView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chattingRoomView)
        chattingRoomView.delegate = self
        chattingRoomView.allowsSelection = false
    }
    
    private func configureLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Message> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = item.content
            cell.contentConfiguration = content
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
        NSLayoutConstraint.activate([
            chattingRoomView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chattingRoomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            chattingRoomView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            chattingRoomView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

// MARK: UICollectionView Delegate Protocol Confirmation
extension ChattingRoomViewController: UICollectionViewDelegate {
    
}

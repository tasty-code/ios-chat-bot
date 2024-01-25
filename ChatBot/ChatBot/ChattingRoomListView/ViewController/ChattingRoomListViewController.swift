import UIKit

final class ChattingRoomListViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    // MARK: Namespace
    private enum Constants {
        static let buttonImageName: String = "square.and.pencil"
    }
    
    // MARK: View Components
    private lazy var chattingRoomListView: UICollectionView! = {
        let chattingRoomListView = UICollectionView(frame: view.bounds, collectionViewLayout: configureLayout())
        chattingRoomListView.translatesAutoresizingMaskIntoConstraints = false
        return chattingRoomListView
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
        configureNavigationBar()
        configureHierarchy()
        configureConstraints()
        configureDataSource()
    }
}

// MARK: Private Methods
extension ChattingRoomListViewController {
    @objc private func pushToNewChattingRoomViewController() {
        let newChattingRoomViewController = ChattingRoomViewController(networkManager: networkManager)
        self.navigationController?.pushViewController(newChattingRoomViewController, animated: true)
    }
}

// MARK: DataSource Controls
extension ChattingRoomListViewController {
    private enum Section: CaseIterable {
        case main
    }
    
    private struct Item: Hashable {
        let id: String
    }
}

// MARK: ChattingRoomListView Configuration Methods
extension ChattingRoomListViewController {
    private func configureNavigationBar() {
        let navigationTitle = "MyChatBot"
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: Constants.buttonImageName), style: .plain, target: self, action: #selector(pushToNewChattingRoomViewController))
        self.navigationItem.title = navigationTitle
        self.navigationItem.setRightBarButton(rightBarButtonItem, animated: true)
    }
    
    private func configureHierarchy() {
        view.addSubview(chattingRoomListView)
    }
    
    private func configureLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { cell, indexPath, itemIdentifier in
            
        }
    }
}

// MARK: Autolayout Methods
extension ChattingRoomListViewController {
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            chattingRoomListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chattingRoomListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            chattingRoomListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            chattingRoomListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

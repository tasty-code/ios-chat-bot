import UIKit

final class ChattingRoomListViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    // MARK: View Components
    private lazy var chattingRoomListView: UICollectionView! = {
        let chattingRoomListView = UICollectionView(frame: view.bounds, collectionViewLayout: configureLayout())
        chattingRoomListView.translatesAutoresizingMaskIntoConstraints = false
        return chattingRoomListView
    }()
    
    // MARK: Properties
    private var dataSource: DataSource! = nil
    private var snapshot: Snapshot! = Snapshot()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureConstraints()
        configureDataSource()
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
    private func configureHierarchy() {
        view.addSubview(chattingRoomListView)
    }
    
    private func configureLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.headerMode = .supplementary
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
    private func configureDataSource() {
//        let headerRegistration = UICollectionView.SupplementaryRegistration(elementKind: , handler: <#T##UICollectionView.SupplementaryRegistration<Supplementary>.Handler##UICollectionView.SupplementaryRegistration<Supplementary>.Handler##(_ supplementaryView: Supplementary, _ elementKind: String, _ indexPath: IndexPath) -> Void#>)
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Item> { cell, indexPath, itemIdentifier in
            <#code#>
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

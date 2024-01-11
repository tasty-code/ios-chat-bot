import UIKit

final class ChattingRoomViewController: UIViewController {
    private lazy var chattingRoomView: UICollectionView = {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let chattingRoomView = ChattingRoomView(frame: .zero, collectionViewLayout: layout)
        chattingRoomView.dataSource = self
        chattingRoomView.delegate = self
        chattingRoomView.register(MessageCell.self, forCellWithReuseIdentifier: MessageCell.identifier)
        chattingRoomView.translatesAutoresizingMaskIntoConstraints = false
        return chattingRoomView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: Autolayout Methods
extension ChattingRoomViewController {
    private func setUpLayout() {
        
    }
    
    private func setUpConstraints() {
        
    }
}

// MARK: UICollectionView Delegate, DataSource Protocol Confirmation
extension ChattingRoomViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
}

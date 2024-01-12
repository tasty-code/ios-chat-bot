import UIKit

final class MessageCell: UICollectionViewListCell {
    // MARK: Namespace
    enum Constants {
        static let defaultMargin: CGFloat = 4
    }
    
    
    // MARK: View Components
    private lazy var bubbleLabel: UILabel! = {
        let margin = Constants.defaultMargin
        let label = UILabel()
        label.numberOfLines = .zero
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.directionalLayoutMargins = NSDirectionalEdgeInsets(top: margin,
                                                                 leading: margin,
                                                                 bottom: margin,
                                                                 trailing: margin)
        return label
    }()
}

// MARK: Configure Cell Methods
extension MessageCell {
    func configureCell(with message: Message) {
        contentView.addSubview(bubbleLabel)
        
        bubbleLabel.text = message.content
        
        NSLayoutConstraint.activate([
            bubbleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            bubbleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bubbleLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 2/3)
        ])
        
        if message.role == .user {
            bubbleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        } else {
            bubbleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        }
    }
}

import UIKit

protocol UICollectionViewCellIdentifiable {
    static var identifier: String { get }
}

extension UICollectionViewCellIdentifiable {
    static var identifier: String { String(describing: MessageCell.self) }
}

final class MessageCell: UICollectionViewCell, UICollectionViewCellIdentifiable {
    private weak var textView: UITextView!
}

import UIKit

final class MessageCell: UICollectionViewListCell {
    func forceDirection(role: Role) {
        switch role {
        case .assistant: MessageCell.userInterfaceLayoutDirection(for: .forceRightToLeft)
        case .user: MessageCell.userInterfaceLayoutDirection(for: .forceLeftToRight)
        default: MessageCell.userInterfaceLayoutDirection(for: .unspecified)
        }
    }
}

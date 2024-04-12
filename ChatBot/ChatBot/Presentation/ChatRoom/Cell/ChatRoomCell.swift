import UIKit

final class ChatRoomCell: UICollectionViewListCell {
    static let identifier = "ChatRoomCell"
    
    var viewModel: ChatRoomCellViewModel! {
        didSet { setupViewModel() }
    }
    
    var bubbleView = ChatBubbleView()
    var leadingOrTrailingConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        commonInit()
    }
    
    private func commonInit() {
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bubbleView)
        
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.0),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12.0),
            bubbleView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.66)
        ])
    }
    
    private func setupViewModel() {
        
        bubbleView.chatLabel.text = viewModel.contentMessage
        bubbleView.outcoming = viewModel.contentRole

        leadingOrTrailingConstraint.isActive = false
        if viewModel.contentRole == .user {
            leadingOrTrailingConstraint = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12.0)
        } else {
            leadingOrTrailingConstraint = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12.0)
        }
        leadingOrTrailingConstraint.isActive = true
    }
}

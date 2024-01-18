import UIKit

final class MessageCellContentView: UIView, UIContentView {
    private enum Constants {
        static let labelWidthRatio: CGFloat = 2/3
        static let defaultMargin: CGFloat = 30
    }
    
    private lazy var messageView: MessageView! = {
        let messageView = MessageView(configuration: MessageViewContentConfiguration())
        addSubview(messageView)
        messageView.backgroundColor = .clear
        messageView.translatesAutoresizingMaskIntoConstraints = false
        return messageView
    }()

    private var appliedConfiguration: MessageCellContentConfiguration!
    
    var configuration: UIContentConfiguration {
        get { appliedConfiguration }
        set {
            guard let newConfiguration = newValue as? MessageCellContentConfiguration else { return }
            apply(configuration: newConfiguration)
        }
    }
    
    private var leading: NSLayoutConstraint? = nil
    private var trailing: NSLayoutConstraint? = nil
    
    init(configuration: MessageCellContentConfiguration) {
        super.init(frame: .zero)
        
        leading = messageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.defaultMargin)
        trailing = messageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.defaultMargin)
        
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) 없음")
    }
}

// MARK: Configuration
extension MessageCellContentView {
    private func apply(configuration: MessageCellContentConfiguration) {
        guard appliedConfiguration != configuration else { return }
        appliedConfiguration = configuration
        
        setUpConstraintsByRole()
        updateMessageViewConfiguration(configuration: configuration)
    }
    
    private func updateMessageViewConfiguration(configuration: MessageCellContentConfiguration) {
        var messageViewConfiguration = MessageViewContentConfiguration()
        messageViewConfiguration.text = configuration.text
        messageViewConfiguration.role = configuration.role
        messageView.updateConfiguration(configuration: messageViewConfiguration)
    }
}

// MARK: Autolayout Methods
extension MessageCellContentView {
    private func setUpConstraintsByRole() {
        let margin = Constants.defaultMargin
        let labelWidthRatio = Constants.labelWidthRatio
        
        NSLayoutConstraint.activate([
            messageView.topAnchor.constraint(equalTo: self.topAnchor, constant: margin),
            messageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margin),
            messageView.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: labelWidthRatio)
        ])
        
        if appliedConfiguration.role == .user {
            leading?.isActive = false
            trailing?.isActive = true
        } else {
            leading?.isActive = true
            trailing?.isActive = false
        }
    }
}

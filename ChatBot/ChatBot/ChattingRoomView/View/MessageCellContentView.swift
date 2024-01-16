import UIKit

final class MessageCellContentView: UIView, UIContentView {
    private enum Constants {
        static let labelWidthRatio: CGFloat = 2/3
        static let defaultMargin: CGFloat = 20
    }
    
    private let bubbleView: BubbleView = BubbleView()

    private var appliedConfiguration: MessageCellContentConfiguration!
    
    private var leading: NSLayoutConstraint? = nil
    private var trailing: NSLayoutConstraint? = nil
    
    var configuration: UIContentConfiguration {
        get { appliedConfiguration }
        set {
            guard let newConfiguration = newValue as? MessageCellContentConfiguration else { return }
            apply(configuration: newConfiguration)
        }
    }
    
    init(configuration: MessageCellContentConfiguration) {
        super.init(frame: .zero)

        setUpHierarchy()
        
        leading = bubbleView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.defaultMargin)
        trailing = bubbleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.defaultMargin)
        
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) 없음")
    }
    
    private func setUpHierarchy() {
        addSubview(bubbleView)
        
        bubbleView.backgroundColor = .clear
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func apply(configuration: MessageCellContentConfiguration) {
        guard appliedConfiguration != configuration else { return }
        appliedConfiguration = configuration
        
        bubbleView.role = configuration.role
        bubbleView.text = configuration.text
        
        setUpConstraintsByRole()
    }
    
    private func setUpConstraintsByRole() {
        let margin = Constants.defaultMargin
        let labelWidthRatio = Constants.labelWidthRatio
        
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: self.topAnchor, constant: margin),
            bubbleView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margin),
            bubbleView.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: labelWidthRatio)
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

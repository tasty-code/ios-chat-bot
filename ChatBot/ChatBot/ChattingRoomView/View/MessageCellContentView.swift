import UIKit

final class MessageCellContentView: UIView, UIContentView {
    private enum Constants {
        static let labelWidthRatio: CGFloat = 2/3
        static let defaultMargin: CGFloat = 10
    }
    
    private lazy var label: UILabel = UILabel()
    
    private var appliedConfiguration: MessageCellContentConfiguration!
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
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) 없음")
    }
    
    private func setUpHierarchy() {
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.lineBreakMode = .byWordWrapping
    }
    
    private func apply(configuration: MessageCellContentConfiguration) {
        guard appliedConfiguration != configuration else { return }
        appliedConfiguration = configuration
        
        label.text = configuration.text
        
        setUpConstraintsByRole()
    }
    
    private func setUpConstraintsByRole() {
        let margin = Constants.defaultMargin
        let labelWidthRatio = Constants.labelWidthRatio
        
        NSLayoutConstraint.deactivate(label.constraints)
        
        if appliedConfiguration.role == .user {
            label.semanticContentAttribute = .forceRightToLeft
            
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: self.topAnchor, constant: margin),
                label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margin),
                label.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: labelWidthRatio),
                label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margin)
            ])
        } else {
            label.semanticContentAttribute = .forceLeftToRight
            
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: self.topAnchor, constant: margin),
                label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margin),
                label.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: labelWidthRatio),
                label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin)
            ])
        }
    }
}

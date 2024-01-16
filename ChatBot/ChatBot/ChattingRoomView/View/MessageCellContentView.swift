import UIKit

final class MessageCellContentView: UIView, UIContentView {
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
        NSLayoutConstraint.deactivate(label.constraints)
        
        if appliedConfiguration.role == .user {
            label.semanticContentAttribute = .forceRightToLeft
            
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: self.topAnchor),
                label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                label.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 2/3),
                label.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
        } else {
            label.semanticContentAttribute = .forceLeftToRight
            
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: self.topAnchor),
                label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                label.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 2/3),
                label.leadingAnchor.constraint(equalTo: self.leadingAnchor)
            ])
        }
    }
}

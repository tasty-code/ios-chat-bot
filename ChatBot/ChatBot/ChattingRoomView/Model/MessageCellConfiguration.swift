import UIKit

struct MessageCellContentConfiguration: UIContentConfiguration, Hashable {
    var text: String? = nil
    var role: Role? = nil
    
    func makeContentView() -> UIView & UIContentView {
        return MessageCellContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> MessageCellContentConfiguration {
        return self
    }
}

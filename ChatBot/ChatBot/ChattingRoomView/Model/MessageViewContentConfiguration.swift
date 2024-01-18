import UIKit

struct MessageViewContentConfiguration: UIContentConfiguration, Hashable {
    var text: String? = nil
    var role: Role? = nil
    
    func makeContentView() -> UIView & UIContentView {
        return MessageContentView()
    }
    
    func updated(for state: UIConfigurationState) -> MessageViewContentConfiguration {
        return self
    }
}

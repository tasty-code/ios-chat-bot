import Foundation
import Combine

final class ChatRoomCellViewModel {
    @Published var contentMessage: String = ""
    @Published var contentRole: Role = .user
        
    private let message: ChatRoomModel
    
    init(message: ChatRoomModel) {
        self.message = message
        
        setupBinding()
    }
    
    private func setupBinding() {
        contentMessage = message.content
        contentRole = message.role
    }
}

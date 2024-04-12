import Foundation

enum Section {
    case chat
}

struct ChatRoomModel: Hashable {
    let id: UUID = UUID()
    let content: String
    let role: Role
}

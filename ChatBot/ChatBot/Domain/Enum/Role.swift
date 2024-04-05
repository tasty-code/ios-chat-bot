enum Role: String {
    case user
    case assistant
    case system
    
    init(rawValue: String) {
        switch rawValue {
        case "user":
            self = .user
        case "assistant":
            self = .assistant
        default:
            self = .system
        }
    }
}


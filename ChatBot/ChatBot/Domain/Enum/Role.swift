enum Role: String {
    case user
    case assistant
    case none
    
    init(rawValue: String) {
        switch rawValue {
        case "user":
            self = .user
        case "assistant":
            self = .assistant
        default:
            self = .none
        }
    }
}


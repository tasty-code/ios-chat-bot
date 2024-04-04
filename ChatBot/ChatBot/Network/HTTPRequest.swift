enum HTTPRequest {
    enum HeaderField {
        case authorization(Authorization)
        case contentType(ContentType)
        
        private var key: String {
            switch self {
            case .authorization:
                return "Authorization"
            case .contentType:
                return "Content-Type"
            }
        }
        
        var header: (key: String, value: String) {
            let key = self.key
            switch self {
            case .authorization(let authorization):
                return (key, authorization.value)
            case .contentType(let contentType):
                return (key, contentType.value)
            }
            
        }
    }
    
    enum Authorization {
        case bearer(token: String)
        
        var value: String {
            switch self {
            case .bearer(let token):
                return "Bearer \(token)"
            }
        }
    }
    
    enum ContentType {
        case application(Application)
        
        var value: String {
            switch self {
            case .application(let application):
                return "application/\(application.constant)"
            }
        }
        
        struct Application {
            let constant: String
            
            init(constant: String) {
                self.constant = constant
            }
            
            static let json: Self = .init(constant: "json")
        }
    }
}

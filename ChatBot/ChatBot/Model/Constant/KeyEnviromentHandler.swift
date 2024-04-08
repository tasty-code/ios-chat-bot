import Foundation

protocol APIKey {
    static var APIKey: String { get }
}

struct Utils: APIKey {
    static var APIKey: String {
        guard let filePath = Bundle.main.path(forResource: "DEBUG-Keys", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath) else { return "" }
        return plist.object(forKey: "API_KEY") as? String ?? ""
    }
}

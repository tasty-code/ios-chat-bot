import Foundation

extension Bundle {
    
    var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "APIKeys", ofType: "plist"),
              let plistDict = NSDictionary(contentsOfFile: filePath) else {
            fatalError("APIKeys.plist를 찾지 못했습니다..")
        }
        
        guard let value = plistDict.object(forKey: "API_KEY") as? String else {
            fatalError("api key를 찾지 못했습니다.")
        }
        
        return value
    }
}

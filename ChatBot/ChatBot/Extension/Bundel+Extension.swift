
import Foundation

extension Bundle {
    
    // 생성한 .plist 파일 경로 불러오기
    var OPENAI_API_KEY: String {
        guard let file = self.path(forResource: "Api_Key", ofType: "plist") else { return "" }
        
        // .plist를 딕셔너리로 받아오기
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        
        // 딕셔너리에서 값 찾기
        guard let key = resource["myApiKey"] as? String else {
            fatalError("API_KEY error")
        }
        return key
    }
}

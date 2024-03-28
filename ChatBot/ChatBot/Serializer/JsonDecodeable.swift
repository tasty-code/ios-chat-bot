import Foundation

struct JsonDecoder: JsonDecodableProtocol {
    
    private let jsonDecoder: JSONDecoder
    
    init(jsonDecoder: JSONDecoder) {
        self.jsonDecoder = jsonDecoder
    }
    
    //STEP1 테스트용 디코더 - 통신 미구현으로 파일로 확인을 위하여
    func decode<T: Decodable>(fileName: String, fileType: String) -> Result<T, JsonError> {
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: fileType) else { return .failure(.decodingError) }
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else { return .failure(.decodingError) }
        guard let decodedData = try? jsonDecoder.decode(T.self, from: jsonData) else { return .failure(.decodingError) }
        return .success(decodedData)
    }
    
    //STEP2 이후 사용할 디코더 - 통신 구현 이후 교체될 예정
    func decode<T: Decodable>(_ data: Data) -> Result<T, JsonError> {
        guard let decodedData = try? jsonDecoder.decode(T.self, from: data)
        else { return .failure(.decodingError) }
        return .success(decodedData)
    }
}

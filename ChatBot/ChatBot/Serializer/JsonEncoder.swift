import Foundation

class JsonEncoder: JsonEncodableProtocol {
    
    private let jsonEncoder: JSONEncoder
    
    init(jsonEncoder: JSONEncoder) {
        self.jsonEncoder = jsonEncoder
    }
    
    func encode<T: Encodable>(of file: T) -> Result<Data?, JsonError> {
        guard let encodedData = try? jsonEncoder.encode(file) else { return .failure(.encodingError) }
        return .success(encodedData)
    }
}

import Foundation

struct JsonEncoder: JsonEncoderProtocol {
    
    private let encoder: JSONEncoder
    
    init(jsonEncoder: JSONEncoder) {
        self.encoder = jsonEncoder
    }
    
    func encode<T: Encodable>(of file: T) -> Result<Data?, JsonError> {
        guard let encodedData = try? encoder.encode(file) else { return .failure(.encodingError) }
        return .success(encodedData)
    }
}

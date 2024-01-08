import Foundation

struct JSONEncodeManager: JSONEncodable {
    private let encoder: JSONEncodable
    
    init(encoder: JSONEncodable = JSONEncoder()) {
        self.encoder = encoder
    }
    
    func encode<T: Encodable>(_ value: T) throws -> Data {
        do {
            let encodedData = try encoder.encode(value)
            return encodedData
        } catch {
            guard let error = error as? EncodingError else {
                throw error
            }
            throw error
        }
    }
}

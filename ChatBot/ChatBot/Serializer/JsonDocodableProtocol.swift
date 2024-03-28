import Foundation

protocol JsonDecodableProtocol {
    func decode<T: Decodable>(fileName: String, fileType: String) -> Result<T, JsonError>
}

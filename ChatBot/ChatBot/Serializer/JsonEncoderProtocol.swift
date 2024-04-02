import Foundation

protocol JsonEncoderProtocol {
    func encode<T: Encodable>(of file: T) -> Result<Data?, JsonError>
}


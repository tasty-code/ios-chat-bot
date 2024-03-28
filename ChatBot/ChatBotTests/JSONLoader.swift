import Foundation

final class JSONLoader {
    static func loadJSON(fileName: String) throws -> Data {
        guard
            let fileLocation = Bundle(
                for: ChatCompletionReponseDTOTests.self
            ).path(
                forResource: fileName,
                ofType: "json"
            )
        else {
            throw BundleResourceError.notFound
        }
        
        do {
            let jsonData = try String(contentsOfFile: fileLocation)
            guard
                let data = jsonData.data(using: .utf8)
            else {
                throw BundleResourceError.failToDecode
            }
            return data
        } catch {
            throw BundleResourceError.notFound
        }
    }
}

enum BundleResourceError: Error {
    case notFound
    case failToDecode
}

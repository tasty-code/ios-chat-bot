import Foundation

struct JsonLoader {
    static func loadjson(fileName: String) -> Data {
        guard let fileLocation = Bundle(for: ChatBotTests.self).path(forResource: fileName, ofType: "json")
        else {
            print("notFound")
            fatalError()        }
        do {
            let jsonData = try String(contentsOfFile: fileLocation)
            guard let data = jsonData.data(using: .utf8) else {
                print("dataError")
                fatalError()
            }
            return data
        } catch {
            print(error)
            fatalError()
        }
    }
}


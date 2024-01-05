import Foundation

final class NetworkManager {
    let encoder = JSONEncoder()
    
    func request(url: URL, completion: @escaping (Data) -> Void) {
        let urlRequest = URLRequest(url: url)
        
//        let encodedToJson = try? encoder.encode(url)
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                print(error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print(response)
                return
            }
            
            print(response.statusCode)
            
            guard let data = data else {
                return
            }
            
            completion(data)
        }.resume()
    }
}

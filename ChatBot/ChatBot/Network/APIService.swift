//
//  APIService.swift
//  ChatBot
//
//  Created by LeeSeongYeon on 3/26/24.
//

import Foundation

//struct APIService {
//    typealias APIResult = (Result<Data, NetworkError>)
//    let session: URLSession
//    init() {
//        self.session = URLSession.shared
//    }
//    
//    func fetchData(with urlRequest: URLRequest) async throws  -> APIResult {
//        let (data, response) = try await session.data(for: urlRequest)
//        return handleDataTaskCompletion(data: data, response: response)
//    }
//}
//
//private extension APIService {
//    func handleDataTaskCompletion(data: Data?, response: URLResponse?) -> APIResult {
//        guard
//            let httpResponse = response as? HTTPURLResponse
//        else {
//            return .failure(.invalidResponseError)
//        }
//        return self.handleHTTPResponse(data: data, httpResponse: httpResponse)
//    }
//    
//    func handleHTTPResponse(data: Data?, httpResponse: HTTPURLResponse) -> APIResult {
//        guard
//            let data = data
//        else {
//            return .failure(.noDataError)
//        }
//        switch httpResponse.statusCode {
//        case 300..<400:
//            return .failure(.redirectionError)
//        case 400..<500:
//            return .failure(.clientError)
//        case 500..<600:
//            return .failure(.serverError)
//        default:
//            return .success(data)
//        }
//    }
//}

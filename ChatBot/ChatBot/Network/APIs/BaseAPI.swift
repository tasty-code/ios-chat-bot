//
//  BaseAPI.swift
//  ChatBot
//
//  Created by EUNJU on 3/28/24.
//

import Foundation

import Alamofire

class BaseAPI {
    
    func judgeStatus<T: Decodable>(
        by statusCode: Int,
        _ data: Data,
        _ type: T.Type
    ) -> NetworkResult<Any> {
        let decoder = JSONDecoder()

        switch statusCode {
        case 200..<300:
            guard let decodedData = try? decoder.decode(T.self, from: data)
            else {
                return .parsingErr
            }
            return .success(decodedData)
        case 400..<500:
            return .requestErr
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}

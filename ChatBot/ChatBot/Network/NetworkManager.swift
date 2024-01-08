//
//  NetworkManager.swift
//  ChatBot
//
//  Created by 김예준 on 1/5/24.
//

import Foundation
import UIKit

final class NetworkManager {
    let defaultSession = URLSession(configuration: .default)
    
    func loadData(request: URLRequest, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        let task = defaultSession.dataTask(with: request) { data, response, error in
            if error != nil {
                completionHandler(.failure(NetworkError.failedTask))
                return
            }
            guard let response = response as? HTTPURLResponse,
                  (200...299) ~= response.statusCode
            else {
                completionHandler(.failure(NetworkError.outOfRangeSuccessCode))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(NetworkError.failedLoadData))
                return
            }
            
            completionHandler(.success(data))
        }
        
        task.resume()
    }
    
}

//
//  AnswerDecoder.swift
//  ChatBot
//
//  Created by 전성수 on 1/8/24.
//

import Foundation

final class AnswerDecoder {
    
    func fetchData(httpBody: Data) {
        NetworkingManager.shared.downloadData(httpBody) { result in
            switch result {
            case .success(let data):
                do {
                    let model = try JSONDecoder().decode(AIAnswerModel.self, from: data)
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

//
//  GPTRequest.swift
//  ChatBot
//
//  Created by 김진웅 on 1/5/24.
//

import Foundation

struct GPTRequest: APIRequestable {
    let baseURL: URL? = URL(string: "")
    let headerFeilds: [String : String]
    let httpBodyData: Data?
    
    init?(httpbodyData: Encodable) {
        guard let apiKey = Bundle.main.gptAPIKey,
              let encodedData = try? JSONEncoder().encode(httpbodyData)
        else {
            return nil
        }
        self.httpBodyData = encodedData
        headerFeilds = [
            "Authroization": apiKey,
            "Content-Type" : "application/json"
        ]
    }
}

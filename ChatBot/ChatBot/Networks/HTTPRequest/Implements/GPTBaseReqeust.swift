//
//  GPTBaseReqeust.swift
//  ChatBot
//
//  Created by 김준성 on 1/8/24.
//

import Foundation

extension Network {
    final class GPTBaseReqeust: HTTPRequestable {
        let urlString: String? = "https://api.openai.com"
        let paths: [String]? = ["v1", "chat", "completions"]
        let headerFields: [String : String]? = nil
        let httpMethod: Network.HTTPMethod = .get
    }
}

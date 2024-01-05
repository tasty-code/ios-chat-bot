//
//  GPTHTTPRequest.swift
//  ChatBot
//
//  Created by 김준성 on 1/4/24.
//

import Foundation

extension Network {
    final class GPTHTTPRequest: HTTPRequestable {
        var urlString: String? = "https://api.openai.com"
        let paths: [String]? = ["v1", "chat", "completions"]
    }
}

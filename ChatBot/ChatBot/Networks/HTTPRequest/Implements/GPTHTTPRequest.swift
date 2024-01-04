//
//  GPTHTTPRequest.swift
//  ChatBot
//
//  Created by 김준성 on 1/4/24.
//

import Foundation

struct GPTHTTPRequest: HTTPRequestable {
    let paths: [String]? = ["v1", "chat", "completions"]
}

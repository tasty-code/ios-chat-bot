//
//  OpenAIURL.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/05.
//

import Foundation

struct OpenAIURL: APIBaseURLProtocol {
    var scheme: String = "https"
    var host: String = "api.openai.com"
    var path: Path
    var parameters: [String : String]?
}

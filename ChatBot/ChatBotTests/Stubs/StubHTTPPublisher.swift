//
//  StubHTTPPublisher.swift
//  ChatBotTests
//
//  Created by 김준성 on 1/26/24.
//

import Combine
import Foundation

@testable import ChatBot

final class StubGPTHTTPPublisher: HTTPPublishable {
    var isNotError: Bool
    
    let response = """
{
  "id": "chatcmpl-8l7V2moUwlwkh1BhV7cDjJl2j8RUx",
  "object": "chat.completion",
  "created": 1706240936,
  "model": "gpt-3.5-turbo-1106",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "안녕! 문제가 있으면 언제든 물어봐줘~"
      },
      "logprobs": null,
      "finish_reason": "stop"
    }
  ],
  "usage": {
    "prompt_tokens": 355,
    "completion_tokens": 24,
    "total_tokens": 379
  },
  "system_fingerprint": "fp_b57c83dd65"
}
""".data(using: .utf8)!
    
    init(isNotError: Bool) {
        self.isNotError = isNotError
    }
    
    func responsePublisher(urlRequest: URLRequest) -> AnyPublisher<Data, ChatBot.GPTError.HTTPError> {
        Future { [unowned self] promise in
            if isNotError {
                promise(.success(response))
            } else {
                promise(.failure(GPTError.HTTPError.invalidURL))
            }
        }
        .eraseToAnyPublisher()
    }
}
    

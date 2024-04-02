//
//  ViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit

final class ViewController: UIViewController {
    
    let jsonDecoder: JsonDecoderProtocol = JsonDecoder(jsonDecoder: JSONDecoder())
    let jsonEncoder: JsonEncoderProtocol = JsonEncoder(jsonEncoder: JSONEncoder())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        loadEncodingData()
    }
    
    private func makeHTTPBody() -> Result<Data?, JsonError> {
        let file = GPTRequestDTO(model: .basic, messages: [Message(role: .system, content: "You are an assistant that occasionally misspells words", toolCalls: nil), Message(role: .user, content: "Tell me a story.", toolCalls: nil)], logprobs: nil)
        
        return jsonEncoder.encode(of: file)
    }
    
    private func loadEncodingData() {
        print("---------")
        let result = makeHTTPBody()
        switch result {
        case .success(let data):
            guard let unwrappedData = data else { return }
            print(String(data:unwrappedData, encoding: .utf8) ?? "")
        case .failure(let error):
            print(error)
        }
    }
    
    private func loadData() {
        let result: Result<GPTResponseDTO, JsonError> = jsonDecoder.decode(fileName: "responseData", fileType: "json")
        switch result {
        case .success(let data):
            print(data)
        case .failure(let error):
            print(error)
        }
    }
}

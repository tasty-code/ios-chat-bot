//
//  ViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit
import Combine

class ViewController: UIViewController {
    let networkService = Network.GPTHTTPService(encoder: JSONEncoder(), decoder: JSONDecoder())
    let requestable: HTTPRequestable = Network.GPTRequest.chatBot(apiKey: Bundle.main.object(forInfoDictionaryKey: "CHAT_BOT_API_KEY") as! String)
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let c = Model.UserMessage(content: "안녕?")
        
        networkService.request(request: requestable, object: Model.GPTCommentDTO(messages: [c]), type: Model.GPTReplyDTO.self)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { reply in
                print(reply.choices)
            }
            .store(in: &cancellables)
    }
}

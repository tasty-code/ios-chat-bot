//
//  ViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit

class ViewController: UIViewController {
    private let chatManager: ChatManager?
    
    init(chatManager: ChatManager?) {
        self.chatManager = chatManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackground()
        chatGPT(userMessage: "집에 가고싶어욧..")
    }
}

// MARK: - Private Method
private extension ViewController {
    func configureBackground() {
        view.backgroundColor = .white
    }
    
    func chatGPT(userMessage: String) {
        Task{
            do {
                guard 
                    let result = try await chatManager?.requestChatResultData(userMessage: userMessage)
                else {
                    return
                }
                print("질문 : \(userMessage)")
                print("결과 : \(result.choices[0].message.content)")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

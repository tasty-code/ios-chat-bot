//
//  ViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit

class ViewController: UIViewController {
    
    var networkManger = NetworkManger()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchChatMessage()
    }
    
    func fetchChatMessage() {
        networkManger.urlDataTaks { result in
            switch result {
            case .success(let data):
                let decodedResult: Result<ChatResponse, NetworkError> = self.networkManger.DecodedData(data: data)
                switch decodedResult {
                case .success(let decodedData):
                    print("Decoded data:", decodedData)
                case .failure(let error):
                    print("Decoding failed with error:", error.localizedDescription)
                }
            case .failure(let error):
                print("Error:", error.localizedDescription)
            }
        }
    }
}

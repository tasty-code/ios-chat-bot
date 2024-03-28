//
//  ViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit

class ViewController: UIViewController {
    
    let jsonDecoder: JsonDecodableProtocol = JsonDecoder(jsonDecoder: JSONDecoder())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
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

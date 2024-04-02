//
//  ViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit

import RxSwift

final class ViewController: UIViewController {
    
    private let service = ChatAPIService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        service.createChat(systemContent: "Hello! How can I assist you today?", 
                           userContent: "Hello!")
            .subscribe(onSuccess: { result in
                print(result)
            }, onFailure: { error in
                print(error)
            })
    }
}

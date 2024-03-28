//
//  ViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit

class ViewController: UIViewController {
    
    let testView: UIView = {
        let testView = UIView()
        testView.backgroundColor = .systemRed
        return testView
    }()
    
    let chatView: ChatBubbleView = ChatBubbleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testView.addSubview(chatView)
        view.addSubview(testView)
    }
}

//
//  ViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//
import UIKit

final class ViewController: UIViewController {
    private let chatView = ChatView()
    
    override func loadView() {
        self.view = chatView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

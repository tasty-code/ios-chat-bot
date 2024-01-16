//
//  ChatViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit
import Combine

final class ChatViewController: UIViewController {
    let label: UILabel = {
        let label = UILabel()
        label.text = "get data"
        label.textAlignment = .center
        label.numberOfLines = .max
        
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("Refresh", for: .normal)
        button.backgroundColor = .systemBlue
        
        return button
    }()
    
    let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private let vm = ChatViewModel()
    private let input: PassthroughSubject<ChatViewModel.InputEvent, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
        
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        input.send(.sendButtonDidTap(prompt: "Hello, My name is Janine. Please remember my name"))
    }
    
    func bind() {
        let output = vm.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .fetchChatDidFail(let error):
                    self?.label.text = error.localizedDescription
                case .fetchChatDidSucceed(let result):
                    self?.label.text = result as? String
                }
            }.store(in: &cancellables)
    }
    
    @objc func buttonTapped() {
        input.send(.sendButtonDidTap(prompt: "what was my name? please call my name and say hello to me with smily face!"))
    }
}

extension ChatViewController {
    func configure() {
        view.addSubview(stack)
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(button)
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

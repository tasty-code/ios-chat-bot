//
//  ChatViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit
import Combine

final class ChatViewController: UIViewController {

    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 16.0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: ChatCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        button.setImage(UIImage(systemName: "arrow.up.circle.fill", withConfiguration: imageConfig), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.clipsToBounds = true
        button.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
        return button
    }()
    
    lazy var inputTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 22
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.backgroundColor = .clear
        
        textView.font = UIFont.preferredFont(forTextStyle: .headline)
        textView.delegate = self
        textView.isScrollEnabled = false
        
        return textView
    }()
    
    private let vm = ChatViewModel()
    private let input: PassthroughSubject<ChatViewModel.InputEvent, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        input.send(.sendButtonDidTap(prompt: "Hello, My name is Janine. Please remember my name"))
    }
    
    @objc func didTapSubmit() {
        inputTextView.resignFirstResponder()
//        fetchMessageForPrompt(prompt: inputTextView.text)
//        guard let sdf = inputTextView.text else { return }
//        messages.append(storeQuestion(prompt: sdf))
//        collectionView.reloadData()
    }
    
    private func configureUI() {
        containerView.addSubview(sendButton)
        
        containerView.addSubview(inputTextView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        view.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalTo: inputTextView.heightAnchor),
            
            sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            sendButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            sendButton.leadingAnchor.constraint(equalTo: inputTextView.trailingAnchor, constant: 10),
            sendButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            
            inputTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            inputTextView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            inputTextView.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -10)
        ])
    }
    
    func bind() {
        let output = vm.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .fetchChatDidFail:
                    return
                case .fetchChatDidSucceed:
                    self?.collectionView.reloadData()
                }
            }.store(in: &cancellables)
    }
    
    @objc func buttonTapped() {
        input.send(.sendButtonDidTap(prompt: "what was my name? please call my name and say hello to me with smily face!"))
    }
}


extension ChatViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatCollectionViewCell.identifier, for: indexPath) as! ChatCollectionViewCell
        
        cell.configure(model: vm, index: indexPath.row)
        return cell
    }
}

extension ChatViewController: UICollectionViewDelegate {
    
}

extension ChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message = vm.getMessage(at: indexPath.row).content
        let estimatedFrame = message.getEstimatedFrame(with: .systemFont(ofSize: 18))
        return CGSize(width: view.bounds.width, height: estimatedFrame.height + 20)
    }
}

extension ChatViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text)
        let size = CGSize(width: view.frame.width - 30, height: .infinity)
        let estimateSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimateSize.height
            }
        }
    }
}


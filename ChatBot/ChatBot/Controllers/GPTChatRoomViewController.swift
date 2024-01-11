//
//  ViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit

final class GPTChatRoomViewController: UIViewController {
    
    // MARK: - UI Components
    
    private lazy var chatCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let userInputTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 20
        textView.layer.borderWidth = 3.0
        textView.layer.borderColor = UIColor.systemGray6.cgColor
        textView.font = .preferredFont(forTextStyle: .body)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.isScrollEnabled = false
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton()
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 40)
        let buttonImage = UIImage(systemName: "arrow.up.circle.fill", withConfiguration: imageConfiguration)
        button.setImage(buttonImage, for: .normal)
        button.contentMode = .scaleToFill
        button.tintColor = .systemCyan
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var userInteractionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.addArrangedSubview(userInputTextView)
        stackView.addArrangedSubview(sendButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userInputTextView.delegate = self
        setupUI()
    }
    
    // MARK: - Private Method
    
    private func setupUI() {
        view.backgroundColor = .white
        
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(chatCollectionView)
        NSLayoutConstraint.activate([
            chatCollectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            chatCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            chatCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
        ])
        
        view.addSubview(userInteractionStackView)
        NSLayoutConstraint.activate([
            userInteractionStackView.topAnchor.constraint(equalTo: chatCollectionView.bottomAnchor, constant: 10),
            userInteractionStackView.leadingAnchor.constraint(equalTo: chatCollectionView.leadingAnchor),
            userInteractionStackView.trailingAnchor.constraint(equalTo: chatCollectionView.trailingAnchor),
            view.keyboardLayoutGuide.topAnchor
                .constraint(equalToSystemSpacingBelow: userInteractionStackView.bottomAnchor, multiplier: 1.0),
            
            userInputTextView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.8),
            userInputTextView.heightAnchor.constraint(equalToConstant: userInputTextView.estimatedSizeHeight)
        ])
    }
    
    private func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        
        let compositionalLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        return compositionalLayout
    }
}

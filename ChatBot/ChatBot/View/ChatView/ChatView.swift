//
//  ChatView.swift
//  ChatBot
//
//  Created by 김경록 on 1/14/24.
//

import UIKit

// MARK: - Delegate Protocol

protocol ChatViewDelegate: AnyObject {
    func submitUserMessage(chatView: ChatView, animationData: Message, userMessage: String)
}

final class ChatView: UIView {
    
    // MARK: - properties
    
    weak var delegate: ChatViewDelegate?
    private var userContentStorage = [Message]()
    private lazy var dataSource = ChatCollectionViewDataSource(collectionView: chatCollectionView)
    
    private lazy var chatCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: ChatCollectionViewCell.reuseIdentifier)
        addSubview(collectionView)
        
        return collectionView
    }()
    
    private lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.layer.cornerRadius = 12
        textView.layer.borderColor = UIColor.systemCyan.cgColor
        textView.layer.borderWidth = 1.0
        textView.backgroundColor = .white
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        textView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    private lazy var contentSendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.up.message"), for: .normal)
        button.tintColor = UIColor.systemCyan
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(submitUserAnswer), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            contentTextView,contentSendButton
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.backgroundColor = .white
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        return stackView
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private methods
    
    @objc private func submitUserAnswer() {
        guard let userMessage = contentTextView.text else {
            return
        }
        configureTextView()
        contentSendButton.isEnabled.toggle()
        delegate?.submitUserMessage(chatView: self, animationData: dataSource.animationData, userMessage: userMessage)
    }
    
    private func configureLayout() {
        self.backgroundColor = .white
        addSubview(chatCollectionView)
        
        NSLayoutConstraint.activate([
            contentTextView.widthAnchor.constraint(equalTo: contentSendButton.widthAnchor, multiplier: 6),
            contentTextView.heightAnchor.constraint(equalToConstant: contentTextView.estimatedSizeHeight),
            
            chatCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            chatCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chatCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: chatCollectionView.bottomAnchor, constant: 3),
            contentStackView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -5),
            contentStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 50),
            contentStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func makeCollectionViewLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 10
        let estimatedHeight: CGFloat = 50
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(estimatedHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func configureTextView() {
        contentTextView.text = nil
        resetTextViewHeight()
        contentTextView.isScrollEnabled = false
    }
    
    // MARK: - Public Method
    
    func updateSnapshot(items: [Message], isFetched: Bool) {
        dataSource.updateSnapshot(items: items, isFetched: isFetched)
    }
    
    func toggleSendButton() {
        contentSendButton.isEnabled.toggle()
    }
    
    func scrollToBottom() {
        let lastItemIndex = chatCollectionView.numberOfItems(inSection: 0) - 1
        
        if lastItemIndex < 0 {
            return
        }
        
        let indexPath = IndexPath(item: lastItemIndex, section: 0)
        chatCollectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    func setTextViewDelegate(_ delegate: UITextViewDelegate) {
        contentTextView.delegate = delegate
    }

    func resetTextViewHeight() {
        contentTextView.heightAnchor.constraint(equalToConstant: contentTextView.estimatedSizeHeight).isActive = true
    }
}

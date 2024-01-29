//
//  ChatRoomView.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/26.
//

import UIKit

final class ChatRoomView: UIView {
    private var chatTextInputView: ChatTextInputView
    private let collectionView = ChatCollectionView(frame: .zero)
    
    init(delegate: ChatTextInputViewButtonDelegate) {
        chatTextInputView = ChatTextInputView(delegate: delegate)
        super.init(frame: .zero)
        chatTextInputViewConfigure()
        collectionViewConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func chatTextInputViewConfigure() {
        addSubview(chatTextInputView)

        NSLayoutConstraint.activate([
            chatTextInputView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            chatTextInputView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            chatTextInputView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -8)
        ])
    }
    
    private func collectionViewConfigure() {
        let safeArea = safeAreaLayoutGuide
        
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: chatTextInputView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

extension ChatRoomView {
    func updateCollectionView(data: [Message]){
        DispatchQueue.main.async { 
            self.collectionView.saveSnapshot(chatRecord: data)
            self.collectionView.scrollToItem(at: IndexPath(row: self.collectionView.numberOfItems(inSection: 0) - 1, section: 0), at: .bottom, animated: false)
        }
    }
}

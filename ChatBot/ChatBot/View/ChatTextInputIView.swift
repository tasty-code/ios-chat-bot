//
//  ChatTextInputIView.swift
//  ChatBot
//
//  Created by 최승범 on 2024/01/12.
//

import UIKit

final class ChatTextInputIView: UIStackView {

    private lazy var textView: UITextView = {
        let textView = UITextView()
        
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = button.frame.width / 2
        
        return button
    }()

    func configure() {
        self.addArrangedSubview(textView)
        self.addArrangedSubview(button)
        
        self.axis = .horizontal
        self.alignment = .center
        self.spacing = 8
        
        NSLayoutConstraint.activate([
            textView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7)
        ])
    }
}

extension ChatTextInputIView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        guard textView.contentSize.height < self.frame.height * 0.15 else {
            textView.isScrollEnabled = true
            return
        }
        
        textView.isScrollEnabled = false
        textView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = textView.estimatedSizeHeight
            }
        }
        
    }
}

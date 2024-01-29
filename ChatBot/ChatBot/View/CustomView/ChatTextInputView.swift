//
//  ChatTextInputView.swift
//  ChatBot
//
//  Created by 최승범 on 2024/01/12.
//

import UIKit

final class ChatTextInputView: UIStackView {
    
    weak var delegate: ChatTextInputViewButtonDelegate?
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.font = .preferredFont(forTextStyle: .body)
        textView.delegate = self
        
        return textView
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        DispatchQueue.main.async {
            button.layer.cornerRadius = button.frame.size.width / 2
        }
        button.backgroundColor = #colorLiteral(red: 0.7607453465, green: 0.8554189801, blue: 1, alpha: 1)
        button.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
        
        return button
    }()
    
    init(delegate: ChatTextInputViewButtonDelegate) {
        super.init(frame: .zero)
        configure()
        self.delegate = delegate
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(textView)
        self.addArrangedSubview(button)
        
        self.axis = .horizontal
        self.alignment = .center
        self.spacing = 8
        self.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            textView.heightAnchor.constraint(equalToConstant: textView.estimatedSizeHeight),
            button.heightAnchor.constraint(equalToConstant: 40),
            button.widthAnchor.constraint(equalTo: button.heightAnchor, multiplier: 1.0)
        ])
    }
}


// MARK: - User Interaction 

extension ChatTextInputView {
    @objc private func tappedButton() {
        if textView.text == "" { return }
        delegate?.sendMessage(textView.text)
        
        button.isEnabled = false
        textView.text = .none

        textView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = textView.estimatedSizeHeight
            }
        }

        button.isEnabled = true
    }
}


// MARK: - TextViewDelegate

extension ChatTextInputView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard textView.contentSize.height < self.frame.width * 0.2 else {
            textView.isScrollEnabled = true
            return
        }
        
        textView.isScrollEnabled = false
        textView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = textView.estimatedSizeHeight
                self.layoutIfNeeded()
            }
        }
    }
}

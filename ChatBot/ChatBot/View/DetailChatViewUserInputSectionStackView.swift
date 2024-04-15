//
//  DetailChatViewUserInputSectionStackView.swift
//  ChatBot
//
//  Created by 권태호 on 4/11/24.
//

import UIKit

class DetailChatViewUserInputSectionStackView: UIStackView {
    var userInputTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderWidth = 0.1
        textView.layer.cornerRadius = 10
        textView.isScrollEnabled = false
        return textView
    }()
    
     var doneButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "arrowshape.up")
        button.setImage(image, for: .normal)
        button.backgroundColor = .black
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureLayoutSubviews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - configure
    private func setupStackView() {
        self.axis = .horizontal
        self.spacing = 5
        self.distribution = .fill
        self.alignment = .center
        addArrangedSubview(userInputTextView)
        addArrangedSubview(doneButton)
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            doneButton.widthAnchor.constraint(equalToConstant: 40),
            doneButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureLayoutSubviews() {
        doneButton.layer.cornerRadius = doneButton.frame.height / 2
    }
}

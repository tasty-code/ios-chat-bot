//
//  ChatBallon.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/12.
//

import UIKit

final class ChatBallon: UIView {
    
    lazy var label: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 100
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("ChatBallon Init Error")
    }
    
    private func configure() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 32),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -32),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
        ])
    }
}

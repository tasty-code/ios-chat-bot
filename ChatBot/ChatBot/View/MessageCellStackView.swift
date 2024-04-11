//
//  MessageCellStackView.swift
//  ChatBot
//
//  Created by 권태호 on 4/11/24.
//

import UIKit

class MessageCellStackView: UIStackView {
    private let contentLabel: UILabel = {
           let label = UILabel()
           label.font = UIFont.systemFont(ofSize: 15)
           label.numberOfLines = 0
           label.layer.cornerRadius = 10
           return label
       }()
       
       private let senderLabel: UILabel = {
           let label = UILabel()
           label.font = UIFont.boldSystemFont(ofSize: 18)
           return label
       }()
       
       override init(frame: CGRect) {
           super.init(frame: frame)
           setupStackView()
       }
       
       required init(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       private func setupStackView() {
           self.axis = .vertical
           self.spacing = 8
           self.distribution = .fill
           self.alignment = .fill
           self.addArrangedSubview(senderLabel)
           self.addArrangedSubview(contentLabel)
       }
       
       func configureStackView(with content: RequestMessageModel) {
           let message = content.content
           contentLabel.text = message
           contentLabel.backgroundColor = content.role == .user ? .systemBlue : .systemGray
           contentLabel.textColor = content.role == .user ? .black : .black
           contentLabel.textAlignment = .left
           senderLabel.text = content.role == .user ? "😁You" : "🤖Bot"
       }
       
       func reset() {
           contentLabel.text = nil
           senderLabel.text = nil
       }
}

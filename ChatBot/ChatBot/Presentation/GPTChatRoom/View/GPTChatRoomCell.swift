//
//  GPTChatRoomCell.swift
//  ChatBot
//
//  Created by 김준성 on 1/11/24.
//

import UIKit

final class GPTChatRoomCell: UICollectionViewCell {
    private lazy var contentLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(contentLabel)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: topAnchor),
            contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configureCell(to message: any GPTMessagable) {
        switch message.role {
        case .system:
            backgroundColor = .blue
        case .user:
            backgroundColor = .systemMint
        case .assistant:
            backgroundColor = .systemPink
        case .tool:
            backgroundColor = .green
        case .waiting:
            backgroundColor = .yellow
        }
        contentLabel.text = message.content
    }
}

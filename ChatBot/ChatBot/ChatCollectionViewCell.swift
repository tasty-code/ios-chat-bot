//
//  ChatCollectionViewCell.swift
//  ChatBot
//
//  Created by 동준 on 1/16/24.
//

import UIKit

class ChatCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ChatTableViewCell"
    
    let promptTextView: UITextView = {
        let view = UITextView()
        view.font = .systemFont(ofSize: 18.0)
        view.textColor = .black
        view.backgroundColor = .white
        view.layer.cornerRadius = 15.0
        view.layer.masksToBounds = false // 기본값
        view.isEditable = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("required init-error")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        promptTextView.text = nil
        
    }
    
    func setupView() {
        contentView.addSubview(promptTextView)
        promptTextView.translatesAutoresizingMaskIntoConstraints = false
        promptTextView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        promptTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func configure(model: ChatViewModel, index: Int) {
        let message = model.getMessage(at: index)
        
        guard message.role != .system, message.role != .tool else { return }
        
        promptTextView.text = message.content
        guard let font = promptTextView.font else { return }
        let estimateFrame = message.content.getEstimatedFrame(with: font)
        promptTextView.widthAnchor.constraint(equalToConstant: estimateFrame.width + 16).isActive = true
        
        switch message.role {
        case .assistant:
            promptTextView.backgroundColor = .systemRed
            promptTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 36).isActive = true
            promptTextView.addTipViewToLeftBottom(with: promptTextView.backgroundColor)
        case .user:
            promptTextView.backgroundColor = .systemBlue
            promptTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -36).isActive = true
            promptTextView.addTipViewToRightBottom(with: promptTextView.backgroundColor)
        default:
            break
        }
    }
}

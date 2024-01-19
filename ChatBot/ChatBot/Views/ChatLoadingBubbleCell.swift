//
//  LoadingIndicatorCell.swift
//  ChatBot
//
//  Created by Janine on 1/17/24.
//

import UIKit

final class ChatLoadingBubbleCell: UICollectionViewCell {
    
    static let identifier = "chat-loading-cell"
    
    let loadingBubble = LoadingBubble()
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupSubviews() {
        addSubview(loadingBubble)
        
        loadingBubble.frame = bounds
        loadingBubble.translatesAutoresizingMaskIntoConstraints = false
        
//        NSLayoutConstraint.activate([
//            loadingBubble.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
//            loadingBubble.heightAnchor.constraint(equalToConstant: 20),
//            loadingBubble.leadingAnchor.constraint(equalTo: leadingAnchor),
//            loadingBubble.centerYAnchor.constraint(equalTo: centerYAnchor)
//        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if loadingBubble.isAnimating {
            loadingBubble.stopAnimating()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

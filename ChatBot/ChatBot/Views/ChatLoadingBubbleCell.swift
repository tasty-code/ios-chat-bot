//
//  LoadingIndicatorCell.swift
//  ChatBot
//
//  Created by Janine on 1/17/24.
//

import UIKit

final class ChatLoadingBubbleCell: UICollectionViewCell {
    
    static let identifier = "chat-loading-cell"
    
    private var insets = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
    private let loadingBubble = LoadingBubble()
    
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if loadingBubble.isAnimating {
            loadingBubble.stopAnimating()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        loadingBubble.frame = bounds.inset(by: insets)
    }
}

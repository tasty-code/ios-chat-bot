//
//  LoadingIndicatorCell.swift
//  ChatBot
//
//  Created by Janine on 1/17/24.
//

import UIKit

final class LoadingIndicatorCell: UICollectionViewCell {
    
    static let identifier = "loading-indicator-cell"
    
    private let newView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .magenta
        
        return view
    }()
    
    private let loadingBubble = LoadingBubble()
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let insets = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        loadingBubble.frame = bounds.inset(by: insets)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if loadingBubble.isAnimating {
            loadingBubble.stopAnimating()
        }
    }
    
    private func startAnimation() {
        loadingBubble.startAnimating()
    }
    
    // MARK: - Private
    
    private func setupSubviews() {
        addSubview(newView)
//        addSubview(loadingBubble)
        
    }
}

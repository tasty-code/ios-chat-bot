//
//  BubbleCell.swift
//  ChatBot
//
//  Created by Rarla on 2024/01/15.
//

import UIKit

class BubbleCell: UICollectionViewCell {
    static let identifier = "BubbleCell"
    
    private let bubbleView: UIView = UIView()
    
    private let paddingLabel: UILabel = {
        let label = UILabel.init(frame: .zero, padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        label.text = "11111"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        paddingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bubbleView.addSubview(paddingLabel)
        bubbleView.backgroundColor = .orange

        paddingLabel.backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configuration() {
            print(111)
    }
}

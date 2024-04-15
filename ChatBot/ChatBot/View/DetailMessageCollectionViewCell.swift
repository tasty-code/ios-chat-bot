//
//  DetailMessageCollectionViewCell.swift
//  ChatBot
//
//  Created by 권태호 on 4/11/24.
//

import UIKit

class DetailMessageCollectionViewCell: UICollectionViewCell {
    static var identifier = String(describing: DetailMessageCollectionViewCell.self)
    
    private let messageCellStackView = MessageCellStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMessageCollectionViewCell()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //셀 높이 동적 제어
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutIfNeeded()
        
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame
        
        return layoutAttributes
    }
    
    private func setupMessageCollectionViewCell() {
        contentView.addSubview(messageCellStackView)
        messageCellStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageCellStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            messageCellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            messageCellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -5),
            messageCellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
    }
    
    func configureMessageCollectionViewCell(with model: RequestMessageModel) {
        messageCellStackView.configureStackView(with: model)
    }
}

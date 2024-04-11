//
//  ChatMessageCollectionView.swift
//  ChatBot
//
//  Created by 권태호 on 4/11/24.
//

import UIKit

class ChatMessageCollectionView: UICollectionView {
    init() {
          let layout = UICollectionViewFlowLayout()
          layout.scrollDirection = .vertical
          super.init(frame: .zero, collectionViewLayout: layout)
          
          self.register(DetailMessageCollectionViewCell.self, forCellWithReuseIdentifier: DetailMessageCollectionViewCell.identifier)
          self.translatesAutoresizingMaskIntoConstraints = false
          self.backgroundColor = .systemBackground
          
          layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
          layout.minimumLineSpacing = 5
      }
      
      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
      
      override func layoutSubviews() {
          super.layoutSubviews()
          guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
          flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // 상, 하, 좌, 우 여백 설정
      }
}

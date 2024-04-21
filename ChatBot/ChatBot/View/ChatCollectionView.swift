//
//  ChatCollectionView.swift
//  ChatBot
//
//  Created by 강창현 on 4/5/24.
//

import UIKit

final class ChatCollectionView: UICollectionView {
  
  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    setupChatCell()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func scrollToBottom() {
    DispatchQueue.main.async {
      guard self.numberOfSections > 0 else { return }
      let indexPath = IndexPath(
        item: self.numberOfItems(inSection: self.numberOfSections - 1) - 1,
        section: self.numberOfSections - 1
      )
      self.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
  }
}

private extension ChatCollectionView {
  func setupChatCell() {
    self.register(ChatCell.self, forCellWithReuseIdentifier: ChatCell.identifier)
  }
}

//
//  ChatCollectionViewDataSource.swift
//  ChatBot
//
//  Created by 강창현 on 4/5/24.
//

import UIKit

enum MessageSection {
  case messages
}

typealias ChatCollectionViewSnapshot = NSDiffableDataSourceSnapshot<MessageSection, RequestDTO>

final class ChatCollectionViewDataSource: UICollectionViewDiffableDataSource<MessageSection, RequestDTO> {
  static let cellProvider: CellProvider = { collectionView, indexPath, model in
    guard
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: ChatCell.identifier,
        for: indexPath
      ) as? ChatCell
    else {
      return ChatCell()
    }
    let message = model.message
    guard message.role != "user" else {
      cell.configureUser(text: message.content)
      return cell
    }
    
    cell.configureSystem(text: message.content)
    return cell
  }
  
  convenience init(collectionView: ChatCollectionView) {
    self.init(collectionView: collectionView, cellProvider: Self.cellProvider)
  }
}

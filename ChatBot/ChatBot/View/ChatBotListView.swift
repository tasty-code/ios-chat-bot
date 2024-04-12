//
//  ChatBotListView.swift
//  ChatBot
//
//  Created by Matthew on 4/12/24.
//

import UIKit
import SnapKit
import Then

final class ChatBotListView: UICollectionView {
    init() {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = false
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        layout.configuration.boundarySupplementaryItems = []
        super.init(frame: .zero, collectionViewLayout: layout)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Method
private extension ChatBotListView {
    func setupCollectionView() {
        self.register(ChatBotMessageCell.self, forCellWithReuseIdentifier: "cell")
        self.backgroundColor = .white
    }
}

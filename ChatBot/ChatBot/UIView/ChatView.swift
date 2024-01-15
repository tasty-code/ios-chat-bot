//
//  ChatView.swift
//  ChatBot
//
//  Created by 김경록 on 1/14/24.
//

import UIKit

final class ChatView: UIView {
    // MARK: - enum
    
    enum Section {
        case main
    }
    
    // MARK: - properties
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Message> = makeDataSource()
    private lazy var snapShot: NSDiffableDataSourceSnapshot<Section, Message> = configureSnapshot()
    
    private lazy var chatCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: ChatCollectionViewCell.reuseIdentifier)
        addSubview(collectionView)
        return collectionView
    }()
    
    private lazy var contentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "대화를 입력해주세요"
        
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 13, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.borderStyle = .none
        textField.layer.cornerRadius = 12
        textField.layer.borderColor = UIColor.systemCyan.cgColor
        textField.layer.borderWidth = 2.0
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var contentSendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("전송", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            contentTextField,contentSendButton
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.backgroundColor = .white
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        return stackView
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        contentSendButton.addTarget(self, action: #selector(submitUserAnswer), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private methods
    
    private func makeCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Message> {
        
        let cellRegistration = UICollectionView.CellRegistration<ChatCollectionViewCell, Message> { (cell, indexPath, identifier) in
            if identifier.role == "assistant" {
                cell.setConstraintAIBubble()
                cell.setChatLabelText(to: identifier.content)
            } else {
                cell.setConstraintUserBubble()
                cell.setChatLabelText(to: identifier.content)
            }
        }
        
        dataSource =  UICollectionViewDiffableDataSource<Section, Message>(collectionView: chatCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Message) -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        return dataSource
    }
    
    private func configureSnapshot()-> NSDiffableDataSourceSnapshot<Section, Message> {
        
        snapShot = NSDiffableDataSourceSnapshot<Section, Message>()
        snapShot.appendSections([.main])
        dataSource.apply(snapShot, animatingDifferences: false)
        return snapShot
    }
    
    private func updateSnapshot(_ item: Message) {
        DispatchQueue.main.async {
            self.snapShot.appendItems([item])
            self.dataSource.apply(self.snapShot, animatingDifferences: false)
        }
    }
    
    private func configureLayout() {
        self.backgroundColor = .white
        NSLayoutConstraint.activate([
            
            chatCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            chatCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chatCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: chatCollectionView.bottomAnchor, constant: 3),
            contentStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            contentStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30),
            contentStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
    }
    
    @objc private func submitUserAnswer() {
        
        guard let userMessage = contentTextField.text else {
            return
        }
        contentTextField.text = nil
        
        updateSnapshot(Message(role: "user", content: userMessage))
        
        guard let endpoint = buildEndpoint(userMessage) else {
            return
        }
        
        NetworkingManager.shared.downloadData(request: endpoint.generateRequest(),
                                              to: AIContentModel.self) { result in
            switch result {
            case .success(let data):
                self.updateSnapshot(data.choices[0].message)
            case .failure(let error):
                print("\(error)가 발생했습니다 얼럿얼럿띄움~~")
            }
        }
    }
    
    private func buildEndpoint(_ userMessage: String) -> Endpointable? {
        guard let apiKey = Bundle.getAPIKey(for: APIKeyName.openAI.description) else {
            return nil
        }
        
        guard let url = URL(string: BaseURL.openAI.description) else {
            return nil
        }
        
        let newMessage = [Message(role: UserContentConstant.UserRole, content: userMessage),
                          Message(role: UserContentConstant.UserRole, content: userMessage)]
        let body = UserContentModel(messages: newMessage)
        
        
        let header: [String: String] = [HeaderFieldName.contentType.description : ContentType.json.description,
                                        HeaderFieldName.authorization.description : "Bearer \(apiKey)"]
        
        let endpoint: Endpointable = ChatBotEndpoint(url: url, httpMethod: .post, httpHeader: header, httpBody: body)
        
        return endpoint
    }
}

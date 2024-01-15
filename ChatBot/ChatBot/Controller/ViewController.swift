//
//  ViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//
import UIKit

enum Section {
    case main
}

class ViewController: UIViewController {
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Message>! = nil
    private var snapShot: NSDiffableDataSourceSnapshot<Section, Message>! = nil
    private var collectionView: UICollectionView! = nil
    
    private let textField: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.textContainerInset = .init(top: 5, left: 5, bottom: 10, right: 10)
        
        return textView
    }()
    
    private let askButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("물어보기", for: .normal)
        
        return button
    }()
    
    private let inputArea: UIStackView = {
        var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.backgroundColor = .blue
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        setAddSubView()
        setConstraint()
        
        askButton.addTarget(self, action: #selector(submitUserAnswer), for: .touchUpInside)
    }
}

//MARK: Operating Method
extension ViewController {
    @objc func submitUserAnswer() {
        
        guard let userMessage = textField.text else {
            return
        }
        textField.text = nil
        
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

//MARK: UIView methods related width layout
extension ViewController {
    private func setAddSubView() {
        view.addSubview(inputArea)
        inputArea.addArrangedSubview(textField)
        inputArea.addArrangedSubview(askButton)
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            inputArea.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            inputArea.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            inputArea.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            inputArea.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            askButton.widthAnchor.constraint(equalTo: inputArea.widthAnchor, multiplier: 0.2),
            askButton.heightAnchor.constraint(equalTo: askButton.widthAnchor)
        ])
    }
    
    private func createLayout() -> UICollectionViewLayout {
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
}

//MARK: CollectionView method related with DiffableDataSource
extension ViewController {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .red
        view.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ChatBubbleCollectionViewCell, Message> { (cell, indexPath, identifier) in
            
            if identifier.role == "assistant" {
                cell.setConstraintAIBubble()
                cell.label.text = identifier.content
            } else {
                cell.setConstraintUserBubble()
                cell.label.text = identifier.content
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Message>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Message) -> UICollectionViewCell? in

            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        snapShot = NSDiffableDataSourceSnapshot<Section, Message>()
        snapShot.appendSections([.main])
        dataSource.apply(snapShot, animatingDifferences: false)
    }
    
    private func updateSnapshot(_ item: Message) {
        snapShot.appendItems([item])
        dataSource.apply(snapShot, animatingDifferences: false)
    }
}

import UIKit

final class ChatRoomView: UIView {
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    lazy var chattingTextView = UITextView()
    lazy var activityIndicationView = ActivityIndicatorView(style: .medium)
    lazy var sendButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "arrow.up.square.fill", withConfiguration: configuration)

        button.setImage(image, for: .normal)
        button.tintColor = UIColor(named: "SunshineYellow")
  
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 40),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        return button
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        addSubviews()
        setupConstraints()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        textStackView.addArrangedSubview(chattingTextView)
        textStackView.addArrangedSubview(sendButton)
        
        let subviews = [collectionView, textStackView, activityIndicationView]
        
        subviews.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func startLoading() {
        collectionView.isUserInteractionEnabled = false
        collectionView.keyboardDismissMode = .interactive
        chattingTextView.isUserInteractionEnabled = false
        activityIndicationView.isHidden = false
        activityIndicationView.startAnimating()
    }
    
    func finishLoading() {
        collectionView.isUserInteractionEnabled = true
        chattingTextView.isUserInteractionEnabled = true
        activityIndicationView.stopAnimating()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 4),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: textStackView.topAnchor, constant: -10),
            
            textStackView.heightAnchor.constraint(equalToConstant: 40),
            textStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            textStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            textStackView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -10),
            
            activityIndicationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicationView.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicationView.heightAnchor.constraint(equalToConstant: 50),
            activityIndicationView.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupViews() {
        collectionView.backgroundColor = .systemBackground
        chattingTextView.font = .preferredFont(forTextStyle: .body)
        chattingTextView.layer.cornerRadius = 10
        chattingTextView.autocorrectionType = .no
        chattingTextView.backgroundColor = .systemBackground
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(40))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        section.interGroupSpacing = 5
        return UICollectionViewCompositionalLayout(section: section)
    }
}

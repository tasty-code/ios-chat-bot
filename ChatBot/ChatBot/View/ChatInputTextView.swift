//
//  ChatInputTextView.swift
//  ChatBot
//
//  Created by Matthew on 4/12/24.
//

import UIKit
import SnapKit
import Then

final class ChatInputTextView: UIView {
    lazy var inputTextField = UITextField().then {
        $0.frame = CGRect(x: 0, y: 0, width: 0, height: 30)
        $0.layer.cornerRadius = $0.layer.frame.height / 2
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.masksToBounds = false
        $0.placeholder = "메세지를 입력해주세요."
    }
    
    lazy var enterButton = UIButton().then {
        let view = UIImageView().then {
            $0.image = UIImage(systemName: "paperplane.circle.fill")
            $0.tintColor = .systemBlue
        }
        
        view.snp.makeConstraints { make in
            make.height.width.equalTo(36)
        }
        
        $0.addSubview(view)
    }

    private lazy var inputStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 10
        $0.distribution = .fillProportionally
        $0.addArrangedSubview(inputTextField)
        $0.addArrangedSubview(enterButton)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraint()
        inputTextField.addLeftPadding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Method
private extension ChatInputTextView {
    func setupConstraint() {
        self.addSubview(inputStackView)
        inputTextField.snp.makeConstraints { make in
            make.width.equalTo(self.snp.width).multipliedBy(0.8)
            make.height.equalTo(30)
        }
        
        inputStackView.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.bottom.equalTo(self.keyboardLayoutGuide.snp.top)
            make.height.equalTo(self.snp.height).multipliedBy(0.07)
        }
    }
}

//
//  ChatViewController.swift
//  ChatBot
//
//  Created by Kim EenSung on 3/29/24.
//

import UIKit

class ChatViewController: UIViewController {
    private let textInputField = UITextField().then {
        $0.borderStyle = .roundedRect
        let sendImage = UIImage(systemName: "arrow.up.circle.fill")
        sendImage?.withTintColor(.systemMint)
        $0.rightView = UIImageView(image: UIImage(systemName: "arrow.up.circle.fill"))
        $0.rightViewMode = .always
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}

extension ChatViewController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(textInputField)
        
        textInputField.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.width.equalTo(view.safeAreaLayoutGuide.snp.width).inset(20)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
        }
    }
}

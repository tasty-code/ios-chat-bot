//
//  GPTPromptSettingViewController.swift
//  ChatBot
//
//  Created by 김준성 on 1/24/24.
//

import Combine
import UIKit

final class GPTPromptSettingViewController: UIViewController {
    private let viewModel: GPTPromptSettingVMProtocol
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .white
        textView.layer.borderWidth = 3
        textView.textColor = .black
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.delegate = self
        textView.addDoneButton(title: "저장", target: self, selctor: #selector(tapDoneButton))
        view.addSubview(textView)
        return textView
    }()
    
    init(viewModel: GPTPromptSettingVMProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        configureUI()
        viewModel.onViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.onViewWillAppear()
    }
    
    private func bind(to viewModel: GPTPromptSettingVMProtocol) {
        viewModel.output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case .fetch(let result):
                    self?.handleFetchString(result)
                case .store:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleFetchString(_ result: Result<String?, Error>) {
        switch result {
        case .success(let content):
            textView.text = content
        case .failure(let error):
            present(UIAlertController(error: error), animated: true)
        }
    }
}

// MARK: - configure UI
extension GPTPromptSettingViewController {
    private func configureUI() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8)
        ])
    }
    
    @objc
    private func tapDoneButton() {
        view.endEditing(true)
    }
}

extension GPTPromptSettingViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        viewModel.storeUpdatePromptSetting(content: textView.text)
    }
}

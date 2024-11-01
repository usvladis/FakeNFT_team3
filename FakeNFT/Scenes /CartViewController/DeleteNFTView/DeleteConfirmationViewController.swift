//
//  DeleteNFTView.swift
//  FakeNFT
//
//  Created by Владислав Усачев on 11.10.2024.
//

import UIKit
import Kingfisher

final class DeleteConfirmationViewController: UIViewController {
    
    private var viewModel: DeleteConfirmationViewModel!

    
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.text = localizedString(key: "removeQuestionText")
        label.textColor = .fontColor
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(localizedString(key: "removeButtonTitle"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitleColor(.redUniversal, for: .normal)
        button.backgroundColor = .buttonColor
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(localizedString(key: "goBackButtonTitle"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitleColor(.backgroudColor, for: .normal)
        button.backgroundColor = .buttonColor
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Публичная функция для установки изображения NFT
    init(viewModel: DeleteConfirmationViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }
    
    private func setupViews() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurEffectView)
        
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        containerView.addSubview(nftImageView)
        containerView.addSubview(warningLabel)
        containerView.addSubview(deleteButton)
        containerView.addSubview(cancelButton)
        
        deleteButton.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Настройки контейнера
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 262),
            containerView.heightAnchor.constraint(equalToConstant: 220),
            
            // Настройки изображения
            nftImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            nftImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            
            // Настройки текста
            warningLabel.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 12),
            warningLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            warningLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // Настройки кнопок
            deleteButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 127),
            deleteButton.heightAnchor.constraint(equalToConstant: 44),
            
            cancelButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 127),
            cancelButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func bindViewModel() {
        viewModel.nftImageURL.bind { [weak self] url in
            if let url = url {
                self?.nftImageView.kf.setImage(with: url)
            }
        }
        
        viewModel.warningText.bind { [weak self] text in
            self?.warningLabel.text = text
        }
        
        viewModel.deleteButtonTitle.bind { [weak self] title in
            self?.deleteButton.setTitle(title, for: .normal)
        }
        
        viewModel.cancelButtonTitle.bind { [weak self] title in
            self?.cancelButton.setTitle(title, for: .normal)
        }
    }
    
    @objc private func handleDelete() {
        viewModel.confirmDelete()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleCancel() {
        viewModel.cancelDelete()
        dismiss(animated: true, completion: nil)
    }
}


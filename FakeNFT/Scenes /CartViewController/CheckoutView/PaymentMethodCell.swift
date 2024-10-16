//
//  PaymentMethodCell.swift
//  FakeNFT
//
//  Created by Владислав Усачев on 11.10.2024.
//

import UIKit

class PaymentMethodCell: UICollectionViewCell {
    
    static let identifier = "PaymentMethodCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .fontColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let shortNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .greenUniversal
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .greyColor
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(shortNameLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 36),
            imageView.heightAnchor.constraint(equalToConstant: 36),
            
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            
            shortNameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4),
            shortNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor)
        ])
    }
    
    func configure(with method: PaymentMethod, isSelected: Bool) {
        imageView.image = method.image
        nameLabel.text = method.name
        shortNameLabel.text = method.shortName
        
        contentView.layer.borderWidth = isSelected ? 1 : 0
        contentView.layer.borderColor = isSelected ? UIColor.buttonColor.cgColor : nil
    }
}


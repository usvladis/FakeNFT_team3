//
//  CatalogTableViewCell.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 10.10.2024.
//

import UIKit
import Kingfisher

// MARK: - CatalogTableViewCell

final class CatalogTableViewCell: UITableViewCell {
    
    // MARK: - Static Properties
    
    static let identifier = "CatalogTableViewCell"
    
    // MARK: - UI Elements
    
    private lazy var topImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 12
        image.kf.indicatorType = .activity
        return image
    }()
    
    private lazy var nameAndCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bodyBold
        return label
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    /// Конфигурирует ячейку с именем, количеством элементов и изображением
    func configure(name: String, count: Int, image: URL) {
        topImage.kf.setImage(
            with: image,
            options: [
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
        nameAndCountLabel.text = "\(name) (\(count))"
    }
    
    // MARK: - Layout Setup
    
    private func setupSubviews() {
        contentView.addSubview(topImage)
        contentView.addSubview(nameAndCountLabel)
    }
    
    private func setupConstraints() {
        let heightConstraint = contentView.heightAnchor.constraint(equalToConstant: 179)
        heightConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            heightConstraint,
            
            topImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            topImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topImage.heightAnchor.constraint(equalToConstant: 140),
            
            nameAndCountLabel.topAnchor.constraint(equalTo: topImage.bottomAnchor, constant: 4),
            nameAndCountLabel.leadingAnchor.constraint(equalTo: topImage.leadingAnchor),
            nameAndCountLabel.trailingAnchor.constraint(equalTo: topImage.trailingAnchor),
        ])
    }
}


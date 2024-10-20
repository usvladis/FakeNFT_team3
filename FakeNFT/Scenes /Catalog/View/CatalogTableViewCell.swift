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
        return image
    }()
    
    private lazy var nameAndCountLabel: UILabel = {
        let nameAndCountLabel = UILabel()
        nameAndCountLabel.translatesAutoresizingMaskIntoConstraints = false
        nameAndCountLabel.font = .bodyBold
        return nameAndCountLabel
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    func configCell(name: String, count: Int, image: String) {
            let urlForImage = URL(string: image)
            topImage.kf.setImage(with: urlForImage)
        nameAndCountLabel.text = "\(name) (\(count))"
    }
    
    
    // MARK: - Layout Setup
    
    private func addSubViews() {
        contentView.addSubview(topImage)
        contentView.addSubview(nameAndCountLabel)
        
        let heightCell = contentView.heightAnchor.constraint(equalToConstant: 179)
        heightCell.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            heightCell,
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

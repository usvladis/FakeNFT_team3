//
//  CatalogTableViewCell.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 10.10.2024.
//

import UIKit

// MARK: - CatalogTableViewCell

final class CatalogTableViewCell: UITableViewCell {
    
    // MARK: - Static Properties
    
    static let identifer = "CatalogTableViewCell"
    
    // MARK: - UI Elements
    
    private lazy var topImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 12
        return image
    }()
    
    private lazy var nameAndCountLable: UILabel = {
        let nameAndCountLable = UILabel()
        nameAndCountLable.translatesAutoresizingMaskIntoConstraints = false
        nameAndCountLable.font = .bodyBold
        return nameAndCountLable
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout Setup
    
    private func addSubViews() {
        contentView.addSubview(topImage)
        contentView.addSubview(nameAndCountLable)
        
        let heightCell = contentView.heightAnchor.constraint(equalToConstant: 179)
        heightCell.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            heightCell,
            topImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            topImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topImage.heightAnchor.constraint(equalToConstant: 140),
            
            nameAndCountLable.topAnchor.constraint(equalTo: topImage.bottomAnchor, constant: 4),
            nameAndCountLable.leadingAnchor.constraint(equalTo: topImage.leadingAnchor),
            nameAndCountLable.trailingAnchor.constraint(equalTo: topImage.trailingAnchor),
            nameAndCountLable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13),
        ])
    }
    
    // MARK: - Configuration
    
    func configCell(name: String, count: Int, image: UIImage) {
        topImage.image = image
        nameAndCountLable.text = "\(name) (\(count))"
    }
}

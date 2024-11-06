//
//  FavoriteNFTCollectionViewCell.swift
//  FakeNFT
//
//  Created by Дмитрий Жуков on 10/18/24.
//

import UIKit

final class FavoriteNFTCollectionViewCell: UICollectionViewCell {
    // MARK: - Public Properties
    static let identifier = "FaforiteNFTCollectionViewCell"
    
    // MARK: - UI Elements
    lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var likeImage: UIImageView = {
        let likeImage = UIImageView()
        likeImage.image = UIImage(named: "heart_fill")
        likeImage.translatesAutoresizingMaskIntoConstraints = false
        return likeImage
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .fontColor
        label.font = .bodyBold
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var starsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var countMoneyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .fontColor
        label.font = .caption1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    override init(
        frame: CGRect
    ) {
        super.init(
            frame: frame
        )
        configureView()
    }
    
    required init?(
        coder: NSCoder
    ) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ViewConfigurable
extension FavoriteNFTCollectionViewCell: ViewConfigurable {
    func addSubviews() {
        let subViews = [
            nftImageView,
            likeImage,
            nameLabel,
            starsImageView,
            countMoneyLabel
        ]
        subViews.forEach {
            contentView.addSubview($0)
        }
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 80),
            nftImageView.heightAnchor.constraint(equalToConstant: 80),
            
            likeImage.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeImage.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            likeImage.widthAnchor.constraint(equalToConstant: 29.63),
            likeImage.heightAnchor.constraint(equalToConstant: 29.63),
            
            nameLabel.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 7),
            nameLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 12),
            nameLabel.widthAnchor.constraint(equalToConstant: 76),
            
            starsImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            starsImageView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            starsImageView.widthAnchor.constraint(equalToConstant: 68),
            starsImageView.heightAnchor.constraint(equalToConstant: 12),
            
            countMoneyLabel.topAnchor.constraint(equalTo: starsImageView.bottomAnchor, constant: 8),
            countMoneyLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            countMoneyLabel.widthAnchor.constraint(equalToConstant: 76),
            countMoneyLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configureView() {
        addSubviews()
        addConstraints()
    }
}

extension FavoriteNFTCollectionViewCell {
    func configure(
        with nft: Nft,
        image: UIImage?,
        ratingImage: UIImage?
    ) {
        self.countMoneyLabel.text = "\(nft.price) ETH"
        self.nftImageView.image = image ?? UIImage(named: "placeholder")
        self.starsImageView.image = ratingImage ?? UIImage(named: "rating_0")
        self.nameLabel.text = nft.name
    }
}

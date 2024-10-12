//
//  NFTCellForCollectionView.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 10.10.2024.
//

import UIKit

final class NFTCellForCollectionView: UICollectionViewCell {
    
    static let identifier = "NFTCollectionViewCell"
    
    private lazy var topView: UIView = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var bottomView: UIView = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var likeButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var previewImage: UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
}

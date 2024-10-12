//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 10.10.2024.
//

import UIKit

final class CollectionViewController: UIViewController {
    
    private let viewModel = CollectionViewModel()
    
    private var collection: CollectionModel?
    
    private lazy var topImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 12
        image.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        return image
    }()
    
    private lazy var topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .headline3
        return label
    }()
    
    private lazy var firstAuthorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .caption2
        return label
    }()
    
    private lazy var secondAuthorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .caption1
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .caption2
        label.numberOfLines = .max
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(NFTCellForCollectionView.self, forCellWithReuseIdentifier: NFTCellForCollectionView.reuseIdentifier)
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        addConstraints()
        loadData()
    }
    
    private func loadData() {
        viewModel.fetchCollections {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private func addSubviews() {
        let closeButton = UIBarButtonItem(image: UIImage(named: "back_button"), style: .plain, target: self, action: #selector(dismissViewController))
            closeButton.tintColor = .blackUniversal
            navigationItem.leftBarButtonItem = closeButton
            
            view.addSubview(topImage)
            view.addSubview(topView)
            topView.addSubview(nameLabel)
            topView.addSubview(firstAuthorLabel)
            topView.addSubview(secondAuthorLabel)
            view.addSubview(descriptionLabel)
            view.addSubview(collectionView)
            
            topImage.image = UIImage(named: "CollectionCoverMock")
            nameLabel.text = "Peach"
        firstAuthorLabel.text = localizedString(key:"collectionAuthor")
            secondAuthorLabel.text = "John Doe"
            descriptionLabel.text = "Персиковый — как облака над закатным солнцем в океане. Бла-бла-бла, кто-нибудь это читает? Всем насрать на этот текст, все хотят просто навариться на NFT"
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            topImage.topAnchor.constraint(equalTo: view.topAnchor),
            topImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            topImage.heightAnchor.constraint(equalToConstant: 310),
            
            topView.topAnchor.constraint(equalTo: topImage.bottomAnchor, constant: 16),
            topView.leadingAnchor.constraint(equalTo: topImage.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: topImage.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 64),
            
            nameLabel.topAnchor.constraint(equalTo: topView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -16),
            nameLabel.heightAnchor.constraint(equalToConstant: 28),
            
            firstAuthorLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -5),
            firstAuthorLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            firstAuthorLabel.widthAnchor.constraint(equalToConstant: 115),
            firstAuthorLabel.heightAnchor.constraint(equalToConstant: 18),
            
            secondAuthorLabel.leadingAnchor.constraint(equalTo: firstAuthorLabel.trailingAnchor, constant: 4),
            secondAuthorLabel.heightAnchor.constraint(equalToConstant: 28),
            secondAuthorLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            secondAuthorLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -16),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: topView.bottomAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 72),
            
            collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func dismissViewController() {
            dismiss(animated: true, completion: nil)
        }
    
    func configure(with collection: CollectionModel) {
        self.collection = collection
    }
    
    
}
extension CollectionViewController: UICollectionViewDelegate {
    
}
extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfCollections()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTCellForCollectionView.reuseIdentifier, for: indexPath) as? NFTCellForCollectionView
        else {
            print("Не прошёл каст")
            return UICollectionViewCell()
        }
        
        let nft = viewModel.collection(at: indexPath.row)
        cell.configure(nft: nft)
        
        return cell
    }
    
}
extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 108, height: 192)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let leftAndRightInset: CGFloat = 16
        return UIEdgeInsets(top: 8, left: leftAndRightInset, bottom: 8, right: leftAndRightInset)
    }
    
}

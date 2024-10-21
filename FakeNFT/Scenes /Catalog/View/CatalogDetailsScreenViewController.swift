//
//  CatalogDetailsScreenViewController.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 10.10.2024.
//

import UIKit

final class CatalogDetailsScreenViewController: UIViewController {
    
    private let viewModel: CollectionViewModelProtocol
    
    private var collection: CollectionModel?
    private var collectionViewHeightConstraint: NSLayoutConstraint?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var topImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 12
        image.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        return image
    }()
    
    private lazy var topView: UIView = {
        let topView = UIView()
        topView.translatesAutoresizingMaskIntoConstraints = false
        return topView
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
    
    private lazy var urlButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let font = UIFont.caption1
        button.contentHorizontalAlignment = .left
        button.setTitleColor(UIColor.link, for: .normal)
        button.titleLabel?.font = font
        button.addTarget(self, action: #selector(goToAuthorURL), for: .touchUpInside)
        return button
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
        collection.isScrollEnabled = false
        collection.backgroundColor = .catalogBackgroundColor
        return collection
    }()
    
    init(viewModel: CollectionViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .catalogBackgroundColor
        print("Загрузка экрана каталога")
        addSubviews()
        addConstraints()
        loadData()
        configureNavBar()
    }
    
    private func loadData() {
        print("Загрузка данных из viewModel")
        viewModel.fetchNFTs {
            DispatchQueue.main.async {
                print("Данные загружены, обновляем коллекцию")
                self.collectionView.reloadData()
                self.updateCollectionViewHeight()
                self.configureSubviews()
            }
        }
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        
        let backButton = UIBarButtonItem(
            image: UIImage(named: "back_button"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(topImage)
        contentView.addSubview(topView)
        topView.addSubview(nameLabel)
        topView.addSubview(firstAuthorLabel)
        topView.addSubview(urlButton)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(collectionView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            topImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            topImage.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            topImage.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
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
            
            urlButton.leadingAnchor.constraint(equalTo: firstAuthorLabel.trailingAnchor, constant: 4),
            urlButton.heightAnchor.constraint(equalToConstant: 28),
            urlButton.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            urlButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -16),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: topView.bottomAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 72),
            
            collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 800)
        collectionViewHeightConstraint?.isActive = true
    }
    
    func configureSubviews() {
        let pickedCollection = viewModel.getPickedCollection()
        
        let urlForImage = URL(string: pickedCollection.cover)
        topImage.kf.setImage(
            with: urlForImage,
            options: [
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
        
        nameLabel.text = pickedCollection.name
        urlButton.setTitle(pickedCollection.author, for: .normal)
        firstAuthorLabel.text = localizedString(key: "collectionAuthor")
        descriptionLabel.text = pickedCollection.description
    }
    
    
    
    func updateCollectionViewHeight() {
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        let rows = CGFloat((numberOfItems / 3) + (numberOfItems % 3 == 0 ? 0 : 1))
        let itemHeight: CGFloat = 192
        let verticalSpacing: CGFloat = 8
        
        let totalHeight = rows * itemHeight + (rows - 1) * verticalSpacing
        collectionViewHeightConstraint?.constant = totalHeight
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func goToAuthorURL() {
        
    }
    
    func configure(with collection: CollectionModel) {
        self.collection = collection
    }
}

extension CatalogDetailsScreenViewController: UICollectionViewDelegate {
    
}

extension CatalogDetailsScreenViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfCollections()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTCellForCollectionView.reuseIdentifier,
                                                            for: indexPath) as? NFTCellForCollectionView else {
            assertionFailure("Не удалось dequeued ячейку с идентификатором \(NFTCellForCollectionView.reuseIdentifier) или привести ее к NFTCellForCollectionView")
            return UICollectionViewCell()
        }
        
        let nft = viewModel.collection(at: indexPath.row)
        cell.configure(nft: nft)
        
        return cell
    }
}


extension CatalogDetailsScreenViewController: UICollectionViewDelegateFlowLayout {
    
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

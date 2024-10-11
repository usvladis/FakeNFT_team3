//
//  CheckoutViewController.swift
//  FakeNFT
//
//  Created by Владислав Усачев on 11.10.2024.
//

import UIKit

final class CheckoutViewController: UIViewController {
    private let paymentMethods = PaymentMethod.data()
    
    private var selectedPaymentMethodIndex: IndexPath? = nil
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let sideInset: CGFloat = 16    // Отступ от view справа и слева
        let interItemSpacing: CGFloat = 7 // Расстояние между ячейками
        let itemHeight: CGFloat = 46   // Высота ячейки
        
        let totalWidth = UIScreen.main.bounds.width
        let availableWidth = totalWidth - (sideInset * 2) - interItemSpacing  // Общая доступная ширина для ячеек с учетом отступов и расстояний
        
        let itemWidth = availableWidth / 2 // Два элемента в строку
        
        layout.minimumLineSpacing = interItemSpacing
        layout.minimumInteritemSpacing = interItemSpacing
        layout.sectionInset = UIEdgeInsets(top: 7, left: sideInset, bottom: 7, right: sideInset)
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .backgroudColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PaymentMethodCell.self, forCellWithReuseIdentifier: PaymentMethodCell.identifier)
        return collectionView
    }()
    
    private let agreementLabel: UILabel = {
        let label = UILabel()
        label.text = localizedString(key: "warningUserAgreement")
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .fontColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let agreementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(localizedString(key: "warningUserButton"), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(localizedString(key: "pay"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.backgroundColor = .buttonColor
        button.setTitleColor(.backgroudColor, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroudColor
        setupNavigationBar()
        setupCollectionView()
        setupBottomView()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupNavigationBar() {
        title = localizedString(key: "paymentMethodTitle")
        navigationController?.navigationBar.barTintColor = .backgroudColor
        navigationController?.navigationBar.tintColor = .buttonColor
        navigationController?.navigationBar.prefersLargeTitles = false
        let backButton = UIBarButtonItem(image: UIImage(named: "back_button"), style: .plain, target: self, action: #selector(handleBackButton))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func handleBackButton() {
        dismiss(animated: true)
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150)
        ])
    }
    
    private func setupBottomView() {
        let bottomContainer = UIView()
        bottomContainer.backgroundColor = .greyColor
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomContainer)
        
        bottomContainer.addSubview(agreementLabel)
        bottomContainer.addSubview(agreementButton)
        bottomContainer.addSubview(payButton)
        
        payButton.addTarget(self, action: #selector(handlePayButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            bottomContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomContainer.heightAnchor.constraint(equalToConstant: 186),
            
            agreementLabel.topAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: 16),
            agreementLabel.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 16),
            
            agreementButton.topAnchor.constraint(equalTo: agreementLabel.bottomAnchor),
            agreementButton.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 16),
            
            payButton.topAnchor.constraint(equalTo: agreementButton.bottomAnchor, constant: 16),
            payButton.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor, constant: -16),
            payButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc
    func handlePayButton() {
        let successViewController = SuccessPaymentViewController()
        successViewController.modalPresentationStyle = .fullScreen
        
        present(successViewController, animated: false)
    }
}

extension CheckoutViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paymentMethods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PaymentMethodCell.identifier, for: indexPath) as? PaymentMethodCell else {
            return UICollectionViewCell()
        }
        let method = paymentMethods[indexPath.row]
        let isSelected = selectedPaymentMethodIndex == indexPath // Определяем, выбрана ли ячейка
        cell.configure(with: method, isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPaymentMethodIndex = indexPath
        collectionView.reloadData() // Обновляем коллекцию для отображения выбранной ячейки
    }
}


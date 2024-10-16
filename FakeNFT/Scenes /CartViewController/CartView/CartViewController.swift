//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Владислав Усачев on 09.10.2024.
//

import UIKit
import SwiftUI

// MARK: - Preview
final class CartViewController: UIViewController {
    
    private var nftItems: [NFTItem] = NFTItem.mockData()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .backgroudColor
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NFTItemCell.self, forCellReuseIdentifier: NFTItemCell.identifier)
        return tableView
    }()
    
    private let totalNFTLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .fontColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "5.34 ETH" // Mocked data
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .greenUniversal
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let checkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(localizedString(key: "toPayButtonTitle"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.backgroundColor = .buttonColor
        button.setTitleColor(.backgroudColor, for: .normal)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(named:"filter_button")
        button.tintColor = .buttonColor
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // View setup
        view.backgroundColor = .backgroudColor
        navigationItem.rightBarButtonItem = sortButton
        navigationController?.navigationBar.barTintColor = .backgroudColor
        navigationController?.navigationBar.tintColor = .buttonColor
        
        // Добавляем таргет на нажатие кнопки sortButton
        sortButton.target = self
        sortButton.action = #selector(sortButtonTapped)
        
        setupTableView()
        setupBottomView()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
    }
    
    private func setupBottomView() {
        let bottomContainer = UIView()
        bottomContainer.backgroundColor = .greyColor
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomContainer)
        
        checkoutButton.addTarget(self, action: #selector(checkoutButtonTapped), for: .touchUpInside)
        
        totalNFTLabel.text = "\(nftItems.count) NFT"
        bottomContainer.addSubview(totalAmountLabel)
        bottomContainer.addSubview(totalNFTLabel)
        bottomContainer.addSubview(checkoutButton)
        
        NSLayoutConstraint.activate([
            bottomContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomContainer.heightAnchor.constraint(equalToConstant: 76),
            
            totalNFTLabel.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 16),
            totalNFTLabel.topAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: 16),
            
            totalAmountLabel.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 16),
            totalAmountLabel.topAnchor.constraint(equalTo: totalNFTLabel.bottomAnchor, constant: 2),
            
            checkoutButton.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor, constant: -16),
            checkoutButton.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor),
            checkoutButton.leadingAnchor.constraint(equalTo: totalAmountLabel.trailingAnchor, constant: 24),
            checkoutButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc
    func checkoutButtonTapped() {
        print("checkoutButtonTapped")
        let checkoutViewController = CheckoutViewController()
        let checkoutNavigationViewController = UINavigationController(rootViewController: checkoutViewController)
        checkoutNavigationViewController.modalPresentationStyle = .fullScreen
        
        present(checkoutNavigationViewController, animated: false)
    }
    
    @objc
    func sortButtonTapped() {
        // Создаем UIAlertController в стиле Action Sheet
        let alertController = UIAlertController(title: localizedString(key: "sorting"), message: nil, preferredStyle: .actionSheet)
        
        // Добавляем действие для сортировки по цене
        let sortByPriceAction = UIAlertAction(title: localizedString(key: "sortingByPrice"), style: .default)
        
        // Добавляем действие для сортировки по рейтингу
        let sortByRatingAction = UIAlertAction(title: localizedString(key: "sortingByRating"), style: .default)
        
        // Добавляем действие для сортировки по названию
        let sortByNameAction = UIAlertAction(title: localizedString(key: "sortingByName"), style: .default)
        
        // Добавляем действие для отмены
        let closeAction = UIAlertAction(title: localizedString(key: "close"), style: .cancel)
        
        // Добавляем все действия в UIAlertController
        alertController.addAction(sortByPriceAction)
        alertController.addAction(sortByRatingAction)
        alertController.addAction(sortByNameAction)
        alertController.addAction(closeAction)
        
        // Показываем UIAlertController
        present(alertController, animated: true, completion: nil)
    }
    
    func presentDeleteConfirmationDialog(with image: UIImage) {
        let deleteConfirmationVC = DeleteConfirmationViewController()
        deleteConfirmationVC.configure(with: image)
        deleteConfirmationVC.modalPresentationStyle = .overFullScreen
        deleteConfirmationVC.modalTransitionStyle = .crossDissolve
        present(deleteConfirmationVC, animated: true, completion: nil)
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nftItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NFTItemCell.identifier, for: indexPath) as? NFTItemCell else {
            return UITableViewCell()
        }
        let nftItem = nftItems[indexPath.row]
        cell.configure(with: nftItem)
        cell.buttonAction = { [weak self] in
            self?.presentDeleteConfirmationDialog(with: nftItem.image)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


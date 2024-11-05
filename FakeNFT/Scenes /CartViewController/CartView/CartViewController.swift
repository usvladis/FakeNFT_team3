//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Владислав Усачев on 09.10.2024.
//

import UIKit
import SwiftUI
import Kingfisher
import ProgressHUD

// MARK: - Preview
final class CartViewController: UIViewController {
    
    private let viewModel = CartViewModel()
    private let cartService = CartService.shared //В релиз версии эта строчка уберется
    
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
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .greyColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = localizedString(key: "cartIsEmpty")
        label.textColor = .fontColor
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadNFTItems()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        viewModel.applySavedSortType()
        
        //В релиз версии строчки ниже уберутся, нужны только для демонстрации корзины
        cartService.addNFT(id: "a4edeccd-ad7c-4c7f-b09e-6edec02a812b")
        cartService.addNFT(id: "3434c774-0e0f-476e-a314-24f4f0dfed86")
        cartService.addNFT(id: "c14cf3bc-7470-4eec-8a42-5eaa65f4053c")
    }
    
    private func bindViewModel() {
        viewModel.onItemsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.setupCartInformation()
                self?.updateViewVisibility()
            }
            
        }
        
        viewModel.onLoadingStatusChanged = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.showLoadingIndicator()
                } else {
                    self?.hideLoadingIndicator()
                }
            }
        }
        
        viewModel.onError = { error in
            print("Error loading NFT: \(error)")
        }
    }
    
    private func setupView() {
        view.backgroundColor = .backgroudColor
        navigationItem.rightBarButtonItem = sortButton
        navigationController?.navigationBar.barTintColor = .backgroudColor
        navigationController?.navigationBar.tintColor = .buttonColor
        
        sortButton.target = self
        sortButton.action = #selector(sortButtonTapped)
        
        setupTableView()
        setupBottomView()
        setupPlaceholder()
        
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
        view.addSubview(bottomView)
        
        checkoutButton.addTarget(self, action: #selector(checkoutButtonTapped), for: .touchUpInside)
        
        bottomView.addSubview(totalAmountLabel)
        bottomView.addSubview(totalNFTLabel)
        bottomView.addSubview(checkoutButton)
        
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 76),
            
            totalNFTLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            totalNFTLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            
            totalAmountLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            totalAmountLabel.topAnchor.constraint(equalTo: totalNFTLabel.bottomAnchor, constant: 2),
            
            checkoutButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            checkoutButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            checkoutButton.leadingAnchor.constraint(equalTo: totalAmountLabel.trailingAnchor, constant: 24),
            checkoutButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupPlaceholder() {
        view.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func updateViewVisibility() {
        if viewModel.nftItems.isEmpty {
            // Показываем плейсхолдер
            placeholderLabel.isHidden = false
            
            // Скрываем таблицу и нижнюю панель с информацией
            navigationController?.setNavigationBarHidden(true, animated: false)
            tableView.isHidden = true
            bottomView.isHidden = true
            checkoutButton.isHidden = true
            totalNFTLabel.isHidden = true
            totalAmountLabel.isHidden = true
        } else {
            // Скрываем плейсхолдер
            placeholderLabel.isHidden = true
            
            // Показываем таблицу и нижнюю панель с информацией
            navigationController?.setNavigationBarHidden(false, animated: false)
            tableView.isHidden = false
            bottomView.isHidden = false
            checkoutButton.isHidden = false
            totalNFTLabel.isHidden = false
            totalAmountLabel.isHidden = false
        }
    }
    
    private func setupCartInformation() {
        totalNFTLabel.text = viewModel.getTotalNFTCount()
        totalAmountLabel.text = viewModel.getTotalPrice()
    }
    
    @objc
    func checkoutButtonTapped() {
        print("checkoutButtonTapped")
        // Создаем экземпляр ViewModel
        let checkoutViewModel = CheckoutViewModel()
        
        // Передаем ViewModel в CheckoutViewController
        let checkoutViewController = CheckoutViewController(viewModel: checkoutViewModel)
        let checkoutNavigationViewController = UINavigationController(rootViewController: checkoutViewController)
        checkoutNavigationViewController.modalPresentationStyle = .fullScreen
        
        present(checkoutNavigationViewController, animated: false)
    }
    
    @objc
    func sortButtonTapped() {
        let alertController = UIAlertController(title: localizedString(key: "sorting"), message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: localizedString(key: "sortingByPrice"), style: .default) { _ in self.viewModel.sortByPrice() })
        alertController.addAction(UIAlertAction(title: localizedString(key: "sortingByRating"), style: .default) { _ in self.viewModel.sortByRating() })
        alertController.addAction(UIAlertAction(title: localizedString(key: "sortingByName"), style: .default) { _ in self.viewModel.sortByName() })
        alertController.addAction(UIAlertAction(title: localizedString(key: "close"), style: .cancel))
        
        present(alertController, animated: true)
    }
    
    private func presentDeleteConfirmationDialog(with imageURL: URL, nftId: String) {
        let viewModel = DeleteConfirmationViewModel(
            nftId: nftId,
            nftImageURL: imageURL,
            warningText: localizedString(key: "removeQuestionText"),
            deleteButtonTitle: localizedString(key: "removeButtonTitle"),
            cancelButtonTitle: localizedString(key: "goBackButtonTitle")
        )
        viewModel.onDeleteConfirmed = {[weak self] nftId in
            self?.viewModel.deleteNFT(withId: nftId) // вызываем метод удаления NFT
        }
        viewModel.onCancel = {
            // Обработка отмены
        }

        let deleteConfirmationVC = DeleteConfirmationViewController(viewModel: viewModel)
        deleteConfirmationVC.modalPresentationStyle = .overFullScreen
        present(deleteConfirmationVC, animated: false, completion: nil)
    }
    
    private func showLoadingIndicator() {
        ProgressHUD.show()
        // Скрываем плейсхолдер
        placeholderLabel.isHidden = true
        // Скрываем таблицу и нижнюю панель с информацией
        navigationController?.setNavigationBarHidden(true, animated: false)
        tableView.isHidden = true
        bottomView.isHidden = true
        checkoutButton.isHidden = true
        totalNFTLabel.isHidden = true
        totalAmountLabel.isHidden = true
    }
    
    private func hideLoadingIndicator() {
        ProgressHUD.dismiss()
        
        // Показать UI после завершения загрузки
        updateViewVisibility()
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.nftItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NFTItemCell.identifier, for: indexPath) as? NFTItemCell else {
            return UITableViewCell()
        }
        let nftItem = viewModel.nftItems[indexPath.row]
        cell.configure(with: nftItem)
        
        cell.buttonAction = { [weak self] in
            self?.presentDeleteConfirmationDialog(with: nftItem.imageURL, nftId: nftItem.id)
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


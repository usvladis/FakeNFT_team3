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
    
    private var nftItems: [NFTItem] = []
    private let nftService = SimpleNftService()
    private let cartService = CartService.shared
    
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
        loadNFTItems()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Добавляем таргет на нажатие кнопки sortButton
        sortButton.target = self
        sortButton.action = #selector(sortButtonTapped)
        
        setupView()
        applySavedSortType()
        updateViewVisibility()
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    private func loadNFTItems() {
        let nftIds = cartService.getAllNFTIds()
        
        guard !nftIds.isEmpty else {
            nftItems.removeAll() // очищаем элементы на случай, если они остались от предыдущей загрузки
            updateViewVisibility() // показываем плейсхолдер
            return
        }
        
        showLoadingIndicator()
        nftItems.removeAll()
        for id in nftIds {
            nftService.fetchNFT(by: id) { [weak self] result in
                switch result {
                case .success(let nft):
                    // Пробуем извлечь первый URL из массива изображений
                    if let imageURLString = nft.images.first,
                       let url = URL(string: imageURLString) {
                        let nftItem = NFTItem(
                            id: nft.id,
                            imageURL: url,
                            title: nft.name,
                            price: nft.price,
                            rating: nft.rating
                        )
                        
                        DispatchQueue.main.async {
                            self?.nftItems.append(nftItem)
                            self?.hideLoadingIndicator()
                            self?.tableView.reloadData()
                            self?.setupCartInformation()
                            self?.applySavedSortType()
                            self?.updateViewVisibility()
                        }
                    }
                    
                case .failure(let error):
                    print("Error loading NFT: \(error)")
                }
            }
        }
    }
    
    private func setupView() {
        // View setup
        view.backgroundColor = .backgroudColor
        navigationItem.rightBarButtonItem = sortButton
        navigationController?.navigationBar.barTintColor = .backgroudColor
        navigationController?.navigationBar.tintColor = .buttonColor
        
        setupTableView()
        setupBottomView()
        setupPlaceholder()
        setupCartInformation()
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
        if nftItems.isEmpty {
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
        totalNFTLabel.text = "\(nftItems.count) NFT"
        let totalPrice = nftItems.reduce(0) { $0 + $1.price }
        totalAmountLabel.text = String(format: "%.2f ETH", totalPrice) // Ограничиваем до двух знаков после запятой
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
        // Создаем UIAlertController в стиле Action Sheet
        let alertController = UIAlertController(title: localizedString(key: "sorting"), message: nil, preferredStyle: .actionSheet)
        
        // Добавляем действие для сортировки по цене
        let sortByPriceAction = UIAlertAction(title: localizedString(key: "sortingByPrice"), style: .default) { [weak self] _ in
            self?.sortByPrice()
        }
        
        // Добавляем действие для сортировки по рейтингу
        let sortByRatingAction = UIAlertAction(title: localizedString(key: "sortingByRating"), style: .default) { [weak self] _ in
            self?.sortByRating()
        }
        
        // Добавляем действие для сортировки по названию
        let sortByNameAction = UIAlertAction(title: localizedString(key: "sortingByName"), style: .default) { [weak self] _ in
            self?.sortByName()
        }
        
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
    
    private func presentDeleteConfirmationDialog(with imageURL: URL, nftId: String) {
        let viewModel = DeleteConfirmationViewModel(
            nftId: nftId,
            nftImageURL: imageURL,
            warningText: localizedString(key: "removeQuestionText"),
            deleteButtonTitle: localizedString(key: "removeButtonTitle"),
            cancelButtonTitle: localizedString(key: "goBackButtonTitle")
        )
        viewModel.onDeleteConfirmed = {[weak self] nftId in
            self?.deleteNFT(withId: nftId) // вызываем метод удаления NFT
        }
        viewModel.onCancel = {
            // Обработка отмены
        }

        let deleteConfirmationVC = DeleteConfirmationViewController(viewModel: viewModel)
        present(deleteConfirmationVC, animated: true, completion: nil)
    }
    
    func deleteNFT(withId id: String) {
        if let index = nftItems.firstIndex(where: { $0.id == id }) {
            let nftItem = nftItems[index]
            cartService.removeNFT(id: nftItem.id) // Удаляем ID из CartService
            nftItems.remove(at: index)
            tableView.reloadData()
            setupCartInformation()
            updateViewVisibility() // обновляем интерфейс после удаления
        }
    }
    
    private func sortByPrice() {
        nftItems.sort { $0.price < $1.price }
        UserDefaults.standard.set("price", forKey: "selectedSortType")
        tableView.reloadData()
        updateViewVisibility()
    }
    
    private func sortByRating() {
        nftItems.sort { $0.rating > $1.rating }
        UserDefaults.standard.set("rating", forKey: "selectedSortType")
        tableView.reloadData()
        updateViewVisibility()
    }
    
    private func sortByName() {
        nftItems.sort { $0.title < $1.title }
        UserDefaults.standard.set("name", forKey: "selectedSortType")
        tableView.reloadData()
        updateViewVisibility()
    }
    
    private func applySavedSortType() {
        let savedSortType = UserDefaults.standard.string(forKey: "selectedSortType") ?? "price"
        
        switch savedSortType {
        case "price":
            sortByPrice()
        case "rating":
            sortByRating()
        case "name":
            sortByName()
        default:
            sortByPrice()
        }
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
        return nftItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NFTItemCell.identifier, for: indexPath) as? NFTItemCell else {
            return UITableViewCell()
        }
        let nftItem = nftItems[indexPath.row]
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


//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Дмитрий Жуков on 10/18/24.
//

import UIKit
import SwiftUI

// MARK: - Preview
struct MyNFTViewControllerPreview: PreviewProvider {
    static var previews: some View {
        MyNFTViewController().showPreview()
    }
}

class MyNFTViewController: UIViewController {
    //MARK: - ViewModel
    var viewModel: ProfileViewModel?
    
    //MARK: - UI Elements
    private lazy var backButton: UIButton = {
        let button = UIButton()
        if let imageButton = UIImage(named: "back_button")?.withRenderingMode(.alwaysTemplate) {
            button.setImage(imageButton, for: .normal)
            button.tintColor = .buttonColor
            button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        }
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var sortingButton: UIButton = {
        let button = UIButton()
        if let imageButton = UIImage(named: "filter_button")?.withRenderingMode(.alwaysTemplate) {
            button.setImage(imageButton, for: .normal)
            button.tintColor = .buttonColor
            button.addTarget(self, action: #selector(sortingButtonTapped), for: .touchUpInside)
        }
        button.widthAnchor.constraint(equalToConstant: 42).isActive = true
        button.heightAnchor.constraint(equalToConstant: 42).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .backgroudColor
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MyNFTTableViewCell.self, forCellReuseIdentifier: MyNFTTableViewCell.identifier)
        return tableView
    }()
    
    //MARK: - LifeCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroudColor
        setupNavBar()
        configureView()
        update()
    }
    
    //MARK: - Private Methods
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortingButton)
        navigationItem.title = "Мои NFT"
        let customFont = UIFont.bodyBold
        let attributes: [NSAttributedString.Key: Any] = [
            .font: customFont,
            .foregroundColor: UIColor.buttonColor
        ]
        navigationController?.navigationBar.titleTextAttributes = attributes
    }
    
    @objc
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func sortingButtonTapped(_ sender: UIButton) {
        showSortingAlert()
    }
    
    private func update() {
        if viewModel != nil {
            tableView.reloadData()
        } else {
            print("viewModel is nil")
        }
    }
    
    private func showSortingAlert() {
        let alertController = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "По цене", style: .default) { _ in
            print("Сортировка по цене выбрана")
        })
        
        alertController.addAction(UIAlertAction(title: "По рейтингу", style: .default) { _ in
            print("Сортировка по рейтингу выбрана")
        })
        
        alertController.addAction(UIAlertAction(title: "По названию", style: .default) { _ in
            print("Сортировка по названию выбрана")
            self.viewModel?.sortByName()
            self.tableView.reloadData()
        })
        alertController.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - ViewConfigurable
extension MyNFTViewController: ViewConfigurable {
    func addSubviews() {
        view.addSubview(tableView)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension MyNFTViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.myNFTNames.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyNFTTableViewCell.identifier, for: indexPath) as? MyNFTTableViewCell else {
            return UITableViewCell()
        }
        
        if let nftData = viewModel?.configureNFT(for: indexPath.item, from: .myNFT) {
            
            cell.nftImageView.image = nftData.image
            cell.nameLabel.text = nftData.name
        }
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension MyNFTViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

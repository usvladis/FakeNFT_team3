//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Владислав Усачев on 09.10.2024.
//

import UIKit
import SwiftUI
import ProgressHUD

// MARK: - CatalogViewController
final class CatalogViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel = CatalogViewModel()
    private var servicesAssembly: ServicesAssembly?
    private var filterButton: UIBarButtonItem!
    
    // MARK: - UI Elements
    private lazy var NFTTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CatalogTableViewCell.self, forCellReuseIdentifier: CatalogTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .catalogBackgroundColor
        return tableView
    }()
    
    // MARK: - Initializers
    init(servicesAssembly: ServicesAssembly? = nil) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .catalogBackgroundColor
        setupSubviews()
        loadData()
        configureNavBar()
    }
    
    // MARK: - Navigation Bar Configuration
    private func configureNavBar() {
        let filterImage = UIImage(named: "filter_button")?.withRenderingMode(.alwaysTemplate)
        
        filterButton = UIBarButtonItem(
            image: filterImage,
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped)
        )
        
        filterButton.tintColor = .buttonColor
        navigationItem.rightBarButtonItem = filterButton
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.backgroundColor = .clear
            navigationBar.isTranslucent = true
        }
    }
    
    // MARK: - Setup Methods
    private func setupSubviews() {
        view.addSubview(NFTTableView)
        
        NSLayoutConstraint.activate([
            NFTTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            NFTTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            NFTTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            NFTTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Data Loading
    private func loadData() {
        ProgressHUD.show()
        ProgressHUD.animationType = .circleSpinFade
        viewModel.fetchCollections { [weak self] in
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                self?.NFTTableView.reloadData()
            }
        }
    }
    
    // MARK: - Actions
    @objc private func sortButtonTapped() {
        let alert = UIAlertController(title: localizedString(key: "sorting"), message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: localizedString(key: "close"), style: .cancel, handler: nil)
        
        let sortByTitle = UIAlertAction(title: localizedString(key: "sortingByName"), style: .default) { [weak self] _ in
            self?.viewModel.sortByName {
                DispatchQueue.main.async {
                    self?.NFTTableView.reloadData()
                }
            }
        }
        
        let sortByNumber = UIAlertAction(title: localizedString(key: "sortingByNumber"), style: .default) { [weak self] _ in
            self?.viewModel.sortByCount {
                DispatchQueue.main.async {
                    self?.NFTTableView.reloadData()
                }
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(sortByTitle)
        alert.addAction(sortByNumber)
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension CatalogViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ProgressHUD.show()
        ProgressHUD.animationType = .circleSpinFade
        viewModel.getProfile { [weak self] in
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                guard let self = self,
                      let profile = self.viewModel.profile,
                      let order = self.viewModel.order else { return }
                
                let collectionViewModel = CollectionViewModel(
                    pickedCollection: self.viewModel.collection(at: indexPath.row),
                    model: CollectionModel(networkClient: DefaultNetworkClient(), storage: NftStorageImpl()),
                    profile: profile,
                    order: order
                )
                
                let collectionVC = CatalogDetailsScreenViewController(viewModel: collectionViewModel)
                self.navigationController?.pushViewController(collectionVC, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }
}

// MARK: - UITableViewDataSource
extension CatalogViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfCollections()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CatalogTableViewCell.identifier, for: indexPath) as? CatalogTableViewCell else {
            assertionFailure("Не удалось выполнить приведение к CatalogTableViewCell")
            return UITableViewCell()
        }
        
        let nft = viewModel.collection(at: indexPath.row)
        cell.configure(name: nft.name, count: nft.nfts.count, image: nft.cover)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
}

// MARK: - Preview
struct CatalogViewControllerPreview: PreviewProvider {
    
    static var previews: some View {
        CatalogViewController().showPreview()
    }
}


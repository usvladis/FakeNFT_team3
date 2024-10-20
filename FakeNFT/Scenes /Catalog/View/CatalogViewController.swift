//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Владислав Усачев on 09.10.2024.
//

import UIKit
import SwiftUI

final class CatalogViewController: UIViewController {
    
    private let viewModel = CatalogViewModel()
    private var servicesAssembly: ServicesAssembly?
    private var filterButton: UIBarButtonItem!
    
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
    
    init(servicesAssembly: ServicesAssembly? = nil) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .catalogBackgroundColor
        addSubviews()
        loadData()
        configureNavBar()
    }
    
    private func configureNavBar() {
        let filterImage = UIImage(named: "filter_button")?.withRenderingMode(.alwaysTemplate)
        
        filterButton = UIBarButtonItem(
            image: filterImage,
            style: .plain,
            target: self,
            action: #selector(sortButtonTupped)
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
    
    
    private func addSubviews() {
        view.addSubview(NFTTableView)
        
        NSLayoutConstraint.activate([
            NFTTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            NFTTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            NFTTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            NFTTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func loadData() {
        viewModel.fetchCollections {
            DispatchQueue.main.async {
                self.NFTTableView.reloadData()
            }
        }
    }
    
    @objc private func sortButtonTupped() {
        
        let alert = AlertController(title: localizedString(key:"sorting"), message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: localizedString(key:"close"), style: .cancel, handler: nil)
        let sortByTitle = UIAlertAction(title: localizedString(key:"sortingByName"), style: .default, handler: nil)
        let sortByNumber = UIAlertAction(title: localizedString(key:"sortingByNumber"), style: .default, handler: nil)
        alert.setDimmingColor(UIColor.sortCellBackgroundColor.withAlphaComponent(0.5))
        alert.addAction(cancelAction)
        alert.addAction(sortByTitle)
        alert.addAction(sortByNumber)
        present(alert, animated: true)
    }
    
}

extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collectionVC = CatalogDetailsScreenViewController()
        
        navigationController?.pushViewController(collectionVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }
}


extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfCollections()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CatalogTableViewCell.identifier, for: indexPath) as? CatalogTableViewCell else {
            assertionFailure("Не удалось выполнить приведение к CategoryTableViewСеll")
            return UITableViewCell()
        }
        let nft = viewModel.collection(at: indexPath.row)
        cell.configCell(name: nft.name, count: nft.count, image: nft.cover)
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

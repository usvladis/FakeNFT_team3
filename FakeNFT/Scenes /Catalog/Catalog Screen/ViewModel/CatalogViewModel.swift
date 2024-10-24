//
//  CatalogViewModel.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 10.10.2024.
//

import Foundation
import ProgressHUD

protocol CatalogViewModelProtocol: AnyObject {
    func fetchCollections(completion: @escaping () -> Void)
    func numberOfCollections() -> Int
    func collection(at index: Int) -> NFTModelCatalog
    var reloadTableView: (() -> Void)? { get set }
    func sortByName()
    func sortByCount()
}

class CatalogViewModel: CatalogViewModelProtocol {
    private let catalogModel = CatalogModel(networkClient: DefaultNetworkClient(), storage: NftStorageImpl())
    private let sortOptionKey = "sortOptionKey"
    private var catalog: [NFTModelCatalog] = []
    var reloadTableView: (() -> Void)?
    
    
    func fetchCollections(completion: @escaping () -> Void) {
        ProgressHUD.show()
        ProgressHUD.animationType = .circleSpinFade

        catalogModel.loadCatalog { [weak self] (result: Result<NFTsModelCatalog, any Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                switch result {
                case .success(let catalog):
                    self.catalog = catalog
                    self.applySavedSortOption()
                    completion()
                case .failure(let error):
                    ProgressHUD.showError()
                    print(error.localizedDescription)
                    completion()
                }
            }
        }
    }
    
    func numberOfCollections() -> Int {
        return catalog.count
    }
    
    func collection(at index: Int) -> NFTModelCatalog {
        return catalog[index]
    }
    
    func sortByName() {
        catalog.sort { $0.name < $1.name }
        saveSortOption(.name)
        reloadTableView?()
    }
    
    func sortByCount() {
        catalog.sort { $0.nfts.count > $1.nfts.count }
        saveSortOption(.count)
        reloadTableView?()
    }
    
    private func saveSortOption(_ option: SortOption) {
        UserDefaults.standard.set(option.rawValue, forKey: sortOptionKey)
    }
    
    private func applySavedSortOption() {
        let savedOption = UserDefaults.standard.string(forKey: sortOptionKey)
        switch savedOption {
        case SortOption.name.rawValue:
            sortByName()
        case SortOption.count.rawValue:
            sortByCount()
        default:
            break
        }
    }
}

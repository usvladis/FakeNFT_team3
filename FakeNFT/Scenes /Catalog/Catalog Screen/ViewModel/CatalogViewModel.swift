//
//  CatalogViewModel.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 10.10.2024.
//

import Foundation
import ProgressHUD

// MARK: - CatalogViewModelProtocol
protocol CatalogViewModelProtocol: AnyObject {
    func fetchCollections(completion: @escaping () -> Void)
    func numberOfCollections() -> Int
    func collection(at index: Int) -> NFTModelCatalog
    func getProfile(completion: @escaping () -> Void)
    func sortByName(completion: @escaping () -> Void)
    func sortByCount(completion: @escaping () -> Void)
    var profile: Profile? { get set }
    var order: Order? { get set }
}

// MARK: - CatalogViewModel
final class CatalogViewModel: CatalogViewModelProtocol {
    
    // MARK: - Properties
    private let catalogModel = CatalogModel(networkClient: DefaultNetworkClient(), storage: NftStorageImpl())
    private let sortOptionStorage = SortOptionStorage()
    private var catalog: [NFTModelCatalog] = []
    private let networkClient = DefaultNetworkClient()
    private let orderService = OrderServiceImplK(networkClient: DefaultNetworkClient())
    var profile: Profile?
    var order: Order?
    
    // MARK: - Data Fetching
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
                    self.applySavedSortOption(completion: completion)
                case .failure(let error):
                    ProgressHUD.showError()
                    print("Ошибка загрузки каталога: \(error.localizedDescription)")
                    completion()
                }
            }
        }
    }
    
    // MARK: - Collection Data Accessors
    func numberOfCollections() -> Int {
        return catalog.count
    }
    
    func collection(at index: Int) -> NFTModelCatalog {
        return catalog[index]
    }
    
    // MARK: - Sorting
    func sortByName(completion: @escaping () -> Void) {
        catalog.sort { $0.name < $1.name }
        saveSortOption(.name)
        completion()
    }
    
    func sortByCount(completion: @escaping () -> Void) {
        catalog.sort { $0.nfts.count > $1.nfts.count }
        saveSortOption(.count)
        completion()
    }
    
    private func saveSortOption(_ option: SortOption) {
        sortOptionStorage.save(option: option)
    }
    
    private func applySavedSortOption(completion: @escaping () -> Void) {
        if let savedOption = sortOptionStorage.retrieveSortOption() {
            switch savedOption {
            case .name:
                sortByName(completion: completion)
            case .count:
                sortByCount(completion: completion)
            }
        } else {
            completion()
        }
    }
    
    // MARK: - Profile & Order Loading
    func getProfile(completion: @escaping () -> Void) {
        loadProfile { [weak self] result in
            guard let self = self else {
                completion()
                return
            }
            switch result {
            case .success:
                print("Завершили загрузку профиля, он теперь равен: \(String(describing: self.profile))")
                self.loadOrder {
                    print("Вызвали completion для перехода на другой экран")
                    completion()
                }
            case .failure(let error):
                print("Ошибка загрузки профиля: \(error.localizedDescription)")
                
                completion()
            }
        }
    }
    
    private func loadProfile(completion: @escaping ProfileCompletionK) {
        let request = ProfileRequest()
        networkClient.send(request: request, type: Profile.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let newProfile):
                self.profile = newProfile
                completion(.success(newProfile))
            case .failure(let error):
                completion(.failure(error))
                print("Ошибка загрузки профиля: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadOrder(completion: @escaping () -> Void) {
        print("Начинаем загрузку заказа")
        orderService.loadOrder { [weak self] result in
            switch result {
            case .success(let order):
                self?.order = order
                print("Завершили загрузку заказа, он теперь равен: \(String(describing: self?.order))")
                completion()
            case .failure(let error):
                print("Ошибка загрузки заказа: \(error.localizedDescription)")
            }
        }
    }
}


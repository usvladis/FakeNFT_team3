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
    func getProfile(completion: @escaping () -> Void)
    func sortByName(completion: @escaping () -> Void)
    func sortByCount(completion: @escaping () -> Void)
    var profile: Profile? { get set }
    var order: Order? {get set }
}

final class CatalogViewModel: CatalogViewModelProtocol {
    private let catalogModel = CatalogModel(networkClient: DefaultNetworkClient(), storage: NftStorageImpl())
    private let sortOptionStorage = SortOptionStorage()
    private var catalog: [NFTModelCatalog] = []
    
    private let networkClient = DefaultNetworkClient()
    private let orderService = OrderServiceImpl(networkClient: DefaultNetworkClient())
    var profile: Profile?
    var order: Order?
    
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
    
    func getProfile(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        loadProfile { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(_):
                            print("завершили загрузку профиля, он теперь равен: \(self.profile)")
                            print("Вызываем load order")
                            loadOrder {
                                print("Вызвали комплишн для перехода на другой экран")
                                completion()
                            }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        dispatchGroup.leave()
    }
    
    func loadProfile(completion: @escaping ProfileCompletion) {
        
        let request = ProfileRequest()
        networkClient.send(request: request, type: Profile.self) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let newProfile):
            self.profile = newProfile
            completion(.success(newProfile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadOrder(completion: @escaping () -> Void) {
            print("loadOrder")
            orderService.loadOrder { [weak self] result in
                switch result {
                case .success(let order):
                    self?.order = order
                    print("завершили загрузку Order, он теперь равен: \(self?.order)")
                    completion()
                case .failure(let error):
                    print("Failed to load order: \(error.localizedDescription)")
                }
            }
        }
}

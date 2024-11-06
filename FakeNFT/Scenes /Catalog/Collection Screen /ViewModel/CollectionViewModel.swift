//
//  CollectionViewModel.swift -
//  FakeNFT
//
//  Created by Кирилл Марьясов on 10.10.2024.
//

import UIKit
import ProgressHUD

// MARK: - CollectionViewModelProtocol
protocol CollectionViewModelProtocol: AnyObject {
    func fetchCollections(completion: @escaping () -> Void)
    func numberOfCollections() -> Int
    func collection(at index: Int) -> Nft
    func getPickedCollection() -> NFTModelCatalog
    func getLikes() -> [String]
    func getCart() -> [String]
    func fetchNFTs(completion: @escaping () -> Void)
    func toggleLike(for nftId: String, completion: @escaping () -> Void)
    func toggleCart(for nftId: String, completion: @escaping () -> Void)
}

// MARK: - CollectionViewModel
final class CollectionViewModel: CollectionViewModelProtocol {
    
    // MARK: - Private Properties
    private let collectionModel: CollectionModel
    private var pickedCollection: NFTModelCatalog
    private var NFTsFromCollection: Nfts = []
    private var profile: Profile? = nil
    private var order: Order? = nil
    private var favoriteNFT: [String] = []
    private var cartNFT: [String] = []
    var showErrorAlert: ((String) -> Void)?
    private let profileService = ProfileServiceImpl(networkClient: DefaultNetworkClient(), storage: ProfileStorageImpl())
    private let orderService = OrderServiceImpl(networkClient: DefaultNetworkClient())
    private let cartService = CartService.shared
    
    // MARK: - Initializer
    init(pickedCollection: NFTModelCatalog, model: CollectionModel, profile: Profile, order: Order) {
        self.collectionModel = model
        self.pickedCollection = pickedCollection
        self.profile = profile
        self.favoriteNFT = profile.likes
        self.order = order
        self.cartNFT = order.nfts
    }
    
    // MARK: - Data Fetching Methods
    func fetchCollections(completion: @escaping () -> Void) {
        ProgressHUD.show()
        ProgressHUD.animationType = .circleSpinFade
        
        collectionModel.loadCollection(idArrays: pickedCollection.nfts) { [weak self] (result: Result<Nfts, any Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let nfts):
                self.NFTsFromCollection = nfts
                ProgressHUD.dismiss()
                print("Все NFT загрузились: \(nfts)")
            case .failure(let error):
                ProgressHUD.showError()
                completion()
                print("Ошибка загрузки NFT: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchNFTs(completion: @escaping () -> Void) {
        let idArray = pickedCollection.nfts
        
        collectionModel.loadCollection(idArrays: idArray) { [weak self] (result: Result<Nfts, any Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                switch result {
                case .success(let nfts):
                    self.NFTsFromCollection = nfts
                    completion()
                    print("Все NFT загрузились: \(nfts.count)")
                case .failure(let error):
                    ProgressHUD.showError()
                    print("Ошибка загрузки NFT: \(error.localizedDescription)")
                    completion()
                }
            }
        }
    }
    
    // MARK: - Collection Data Accessors
    func numberOfCollections() -> Int {
        return NFTsFromCollection.count
    }
    
    func collection(at index: Int) -> Nft {
        return NFTsFromCollection[index]
    }
    
    func getPickedCollection() -> NFTModelCatalog {
        return pickedCollection
    }
    
    func getLikes() -> [String] {
        print("Получили массив лайков из модели коллекции: \(favoriteNFT.count)")
        return favoriteNFT
    }
    
    func getCart() -> [String] {
        return cartService.getAllNFTIds()
    }
    
    // MARK: - User Actions
    func toggleLike(for nftId: String, completion: @escaping () -> Void) {
        guard let profile = profile else { return }
        
        if let index = favoriteNFT.firstIndex(of: nftId) {
            favoriteNFT.remove(at: index)
            print("Удалили лайк из массива: \(nftId)")
        } else {
            favoriteNFT.append(nftId)
            print("Добавили в массив лайков: \(nftId)")
        }
        
        profileService.updateProfile(likes: favoriteNFT, avatar: profile.avatar, name: profile.name) { [weak self] result in
            switch result {
            case .success(let updatedProfile):
                print("Обновили массив лайков в профиле")
                self?.profile = updatedProfile
            case .failure(let error):
                self?.showErrorAlert?(error.localizedDescription)
            }
            completion()
        }
    }
    
    func toggleCart(for nftId: String, completion: @escaping () -> Void) {
        guard var order = order else { return }
        
        let nftIds = cartService.getAllNFTIds()
        if !nftIds.contains(nftId) {
            cartService.addNFT(id: nftId)
        } else {
            cartService.removeNFT(id: nftId)
        }
        
        orderService.updateOrder(nftsIds: cartNFT) { [weak self] result in
            switch result {
            case .success(let order):
                print("Обновили заказ")
                self?.order = order
            case .failure(let error):
                self?.showErrorAlert?(error.localizedDescription)
            }
            completion()
        }
    }
}


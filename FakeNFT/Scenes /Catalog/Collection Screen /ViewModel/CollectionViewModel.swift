//
//  CollectionViewModel.swift -
//  FakeNFT
//
//  Created by Кирилл Марьясов on 10.10.2024.
//

import UIKit
import ProgressHUD

protocol CollectionViewModelProtocol: AnyObject {
    func fetchCollections(completion: @escaping () -> Void)
    func numberOfCollections() -> Int
    func collection(at index: Int) -> Nft
    func getPickedCollection() -> NFTModelCatalog
    func getLikes() -> [String]
    func fetchNFTs(completion: @escaping () -> Void)
    func toggleLike(for nftId: String, completion: @escaping () -> Void)
    func toggleCart(for nftId: String, completion: @escaping () -> Void)
}

final class CollectionViewModel: CollectionViewModelProtocol {
    
    private let collectionModel: CollectionModel
    private var pickedCollection: NFTModelCatalog
    private var NFTsFromCollection: Nfts = []
    private var profile: Profile? = nil
    private var favoriteNFT: [String] = []
    private var cartNFT: [String] = []
    var showErrorAlert: ((String) -> Void)?
    private let profileService = ProfileServiceImpl(networkClient: DefaultNetworkClient(), storage: ProfileStorageImpl())
    
    init(pickedCollection: NFTModelCatalog, model: CollectionModel, profile: Profile) {
        self.collectionModel = model
        self.pickedCollection = pickedCollection
        self.profile = profile
        self.favoriteNFT = profile.likes
    }
    
    func fetchCollections(completion: @escaping () -> Void) {
        ProgressHUD.show()
        ProgressHUD.animationType = .circleSpinFade
        
        collectionModel.loadCollection(idArrays: pickedCollection.nfts) { [weak self] (result: Result<Nfts, any Error>) in
            guard let self = self else {return}
            switch result {
            case .success(let nfts):
                self.NFTsFromCollection = nfts
                ProgressHUD.dismiss()
                completion()
                print("Все NFT загрузились: \(nfts)")
            case .failure(let error):
                ProgressHUD.showError()
                print(error.localizedDescription)
                print("NFT не загрузились")
            }
        }
    }
    
    func fetchNFTs(completion: @escaping () -> Void) {
        ProgressHUD.show()
        ProgressHUD.animationType = .circleSpinFade
        
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
                    print(error.localizedDescription)
                    print("NFT не загрузились")
                    completion()
                }
            }
        }
    }
    
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
    
    func toggleLike(for nftId: String, completion: @escaping () -> Void) {
        guard var profile = profile else { return }
        
        if let index = favoriteNFT.firstIndex(of: nftId) {
            favoriteNFT.remove(at: index)
            print("Удалили лайк из массива")
        } else {
            favoriteNFT.append(nftId)
            print("добавлен: ! \(nftId) ! в массив лайков")
        }
        
        profileService.sendExamplePutRequest(likes: favoriteNFT, avatar: profile.avatar, name: profile.name) { [weak self] result in
            switch result {
            case .success(let updatedProfile):
                print("Успешно отправили PUT-запрос на обновление массива")
                self?.profile = updatedProfile
            case .failure(let error):
                self?.showErrorAlert?(error.localizedDescription)
            }
            completion()
        }
    }
    
    func toggleCart(for nftId: String, completion: @escaping () -> Void) {
    }
}

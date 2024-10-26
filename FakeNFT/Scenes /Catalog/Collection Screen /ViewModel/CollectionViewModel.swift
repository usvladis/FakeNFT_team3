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
    func fetchNFTs(completion: @escaping () -> Void)
}

final class CollectionViewModel: CollectionViewModelProtocol {
    
    private let collectionModel: CollectionModel
    private var pickedCollection: NFTModelCatalog
    private var NFTsFromCollection: Nfts = []
    
    init(pickedCollection: NFTModelCatalog, model: CollectionModel) {
        self.collectionModel = model
        self.pickedCollection = pickedCollection
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
}

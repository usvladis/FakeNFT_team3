//
//  CatalogViewModel.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 10.10.2024.
//

import UIKit
import ProgressHUD

protocol CatalogViewModelProtocol: AnyObject {
    func fetchCollections(completion: @escaping () -> Void)
    
    func numberOfCollections() -> Int
    func collection(at index: Int) -> NFTModelCatalog
    
}

class CatalogViewModel: CatalogViewModelProtocol {
    
    private let catalogModel = CatalogModel(networkClient: DefaultNetworkClient(), storage: NftStorageImpl())

    private var catalog: [NFTModelCatalog] = []
    
    func fetchCollections(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        ProgressHUD.show()
        ProgressHUD.animationType = .circleSpinFade
        
        catalogModel.loadCatalog { [weak self] (result: Result<NFTsModelCatalog, any Error>) in
            guard let self = self else {return}
            switch result {
            case .success(let catalog):
                self.catalog = catalog
                ProgressHUD.dismiss()
                completion()
            case .failure(let error):
                ProgressHUD.showError()
                print(error.localizedDescription)
            }
        }
        dispatchGroup.leave()
    }
    
    func numberOfCollections() -> Int {
        return catalog.count
    }
    
    func collection(at index: Int) -> NFTModelCatalog {
        return catalog[index]
    }
}

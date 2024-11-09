//
//  CatalogModel.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 12.10.2024.
//

import Foundation

// MARK: - CatalogModel
final class CatalogModel {
    
    // MARK: - Properties
    private let networkClient: NetworkClient
    private let storage: NftStorage
    
    // MARK: - Initializer
    init(networkClient: NetworkClient, storage: NftStorage) {
        self.networkClient = networkClient
        self.storage = storage
    }
    
    // MARK: - Public Methods
    /// Загружает каталог NFT
    func loadCatalog(completion: @escaping NFTsModelCatalogCompletion) {
        let request = CatalogRequest()
        networkClient.send(request: request, type: NFTsModelCatalog.self) { result in
            switch result {
            case .success(let nft):
                completion(.success(nft))
                print("Каталог загружен успешно")
            case .failure(let error):
                completion(.failure(error))
                print("Ошибка загрузки каталога: \(error.localizedDescription)")
            }
        }
    }
}


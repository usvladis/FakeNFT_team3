//
//  CatalogModel.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 12.10.2024.
//

import Foundation

final class CatalogModel {
    
    private let networkClient: NetworkClient
    private let storage: NftStorage
    
    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }
    
    func loadCatalog(completion: @escaping NFTsModelCatalogCompletion) {
        let request = CatalogRequest()
        networkClient.send(request: request, type: NFTsModelCatalog.self) { result in
            switch result {
            case .success(let nft):
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}

struct CatalogRequest: NetworkRequest {
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections")
    }
    var dto: Dto?
}

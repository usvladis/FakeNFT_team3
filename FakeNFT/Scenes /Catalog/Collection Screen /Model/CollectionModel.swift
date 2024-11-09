//
//  CollectionModel.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 12.10.2024.
//

import Foundation
import ProgressHUD

// MARK: - CollectionModel
final class CollectionModel {
    
    // MARK: - Properties
    private let networkClient: NetworkClient
    private let storage: NftStorage
    
    // MARK: - Initializer
    init(networkClient: NetworkClient, storage: NftStorage) {
        self.networkClient = networkClient
        self.storage = storage
    }
    
    // MARK: - Public Methods
    /// Загружает отдельный NFT по идентификатору
    func loadNft(id: String, completion: @escaping NftCompletion) {
        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: Nft.self) { result in
            switch result {
            case .success(let nft):
                completion(.success(nft))
                print("Загрузилась одна NFT")
            case .failure(let error):
                completion(.failure(error))
                print("Ошибка загрузки NFT: \(error.localizedDescription)")
            }
        }
    }
    
    /// Загружает коллекцию NFT на основе массива идентификаторов
    func loadCollection(idArrays: [String], completion: @escaping NftsCompletion) {
        var nfts: Nfts = []
        let dispatchGroup = DispatchGroup()
        let serialQueue = DispatchQueue(label: "com.yourapp.nfts.serialQueue")
        
        for id in idArrays {
            dispatchGroup.enter()
            loadNft(id: id) { result in
                serialQueue.async {
                    switch result {
                    case .success(let nft):
                        nfts.append(nft)
                    case .failure(let error):
                        print("Ошибка загрузки NFT с id \(id): \(error.localizedDescription)")
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(.success(nfts))
        }
    }
}


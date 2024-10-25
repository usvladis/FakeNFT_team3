//
//  CollectionModel.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 12.10.2024.
//

import Foundation
import ProgressHUD

final class CollectionModel {
    
    private let networkClient: NetworkClient
    private let storage: NftStorage
    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }
    
    func loadNft(id: String, completion: @escaping NftCompletion) {
        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: Nft.self) { result in
            switch result {
            case .success(let nft):
                completion(.success(nft))
                print("Загрузилась одна NFT")
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadCollection(idArrays: [String], completion: @escaping NftsCompletion) {
        var nfts: Nfts = []
        let dispatchGroup = DispatchGroup()
        let serialQueue = DispatchQueue(label: "com.yourapp.nfts.serialQueue")
        
        for id in idArrays {
            dispatchGroup.enter()
            loadNft(id: id) { (result: Result<Nft, any Error>) in
                serialQueue.async {
                    switch result {
                    case .success(let nft):
                        nfts.append(nft)
                    case .failure(let error):
                        print(error.localizedDescription)
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

import Foundation

typealias NftsCompletion = (Result<Nfts, Error>) -> Void

protocol NftService {
    func loadNfts(page: Int, size: Int, completion: @escaping NftsCompletion)
}

final class NftServiceImpl: NftService {
    private let networkClient: NetworkClient
    private let storage: NftStorage

    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }
    
    func loadNfts(page: Int, size: Int, completion: @escaping NftsCompletion) {
        let request = NftsRequest(page: page, size: size)
        networkClient.send(request: request, type: Nfts.self) { result in
            switch result {
            case .success(let nft):
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

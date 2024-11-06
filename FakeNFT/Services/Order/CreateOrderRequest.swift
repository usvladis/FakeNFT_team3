//
//  CreateOrderRequest.swift
//  FakeNFT
//
//  Created by Владислав Усачев on 31.10.2024.
//

import Foundation

struct CreateOrderRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    var httpMethod: HttpMethod = .put
    var dto: Dto?
}

typealias OrderCompletion = (Result<OrderResponse, Error>) -> Void

protocol OrderService {
    func createOrder(nftIds: [String], completion: @escaping OrderCompletion)
}

final class OrderServiceImpl: OrderService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func createOrder(nftIds: [String], completion: @escaping OrderCompletion) {
        let dto = OrderDto(nfts: nftIds)
        let request = CreateOrderRequest(dto: dto)
        
        networkClient.send(request: request, type: OrderResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

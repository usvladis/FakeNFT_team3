//
//  OrderAndPaymentService.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 27.10.2024.
//

import Foundation

// MARK: - Completion Type Aliases
typealias OrderCompletionK = (Result<Order, Error>) -> Void
typealias CurrencyListCompletion = (Result<[Currency], Error>) -> Void
typealias PaymentConfirmationRequest = (Result<Payment, Error>) -> Void

// MARK: - OrderService Protocol
protocol OrderServiceK {
    func loadOrder(completion: @escaping OrderCompletionK)
    func loadCurrencyList(completion: @escaping CurrencyListCompletion)
    func updateOrder(nftsIds: [String], completion: @escaping OrderCompletionK)
    func loadPayment(currencyId: String, completion: @escaping PaymentConfirmationRequest)
}

// MARK: - OrderServiceImpl
/// Реализация сервиса для загрузки и управления заказами, валютами и платежами
final class OrderServiceImplK: OrderServiceK {
    
    // MARK: - Properties
    private let networkClient: NetworkClient
    
    // MARK: - Initializer
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    // MARK: - OrderService Methods
    func loadOrder(completion: @escaping OrderCompletionK) {
        networkClient.send(request: NFTOrderRequest(), type: Order.self) { result in
            switch result {
            case .success(let order):
                print("Order из функции loadOrder в OrderServiceImpl: \(order)")
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadCurrencyList(completion: @escaping CurrencyListCompletion) {
        networkClient.send(request: CurrencyListRequest(), type: [Currency].self) { result in
            switch result {
            case .success(let currencies):
                print("Received currencies: \(currencies)")
                completion(.success(currencies))
            case .failure(let error):
                print("Error loading currency list: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func updateOrder(nftsIds: [String], completion: @escaping OrderCompletionK) {
        let newOrderModel = NewOrderModel(nfts: nftsIds)
        let request = EditOrderRequest(newOrder: newOrderModel)
        
        networkClient.send(request: request, type: Order.self) { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadPayment(currencyId: String, completion: @escaping PaymentConfirmationRequest) {
        networkClient.send(request: PaymentRequest(), type: Payment.self) { result in
            switch result {
            case .success(let payment):
                print("Received payment confirmation: \(payment)")
                completion(.success(payment))
            case .failure(let error):
                print("Error loading payment confirmation: \(error)")
                completion(.failure(error))
            }
        }
    }
}


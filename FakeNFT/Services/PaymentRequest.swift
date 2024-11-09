//
//  PaymentRequest.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 28.10.2024.
//

import Foundation

// MARK: - PaymentRequest
/// Запрос для выполнения платежа по заказу
struct PaymentRequest: NetworkRequest {
    
    // MARK: - Properties
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/1")
    }
    
    var dto: (any Dto)?  // Объект данных для передачи в запросе, если требуется
}


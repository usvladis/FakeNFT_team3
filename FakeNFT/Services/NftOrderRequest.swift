//
//  NftOrderRequest.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 28.10.2024.
//

import Foundation

// MARK: - NFTOrderRequest
/// Запрос для получения или обновления информации о заказе NFT
struct NFTOrderRequest: NetworkRequest {
    
    // MARK: - Properties
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    
    var dto: (any Dto)?  // Объект данных для передачи в запросе, если требуется
}


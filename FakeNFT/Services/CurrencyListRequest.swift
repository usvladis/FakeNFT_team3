//
//  CurrencyListRequest.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 27.10.2024.
//

import Foundation

// MARK: - CurrencyListRequest
/// Запрос для получения списка доступных валют
struct CurrencyListRequest: NetworkRequest {
    
    // MARK: - Properties
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
    }
    
    var dto: (any Dto)?  // Объект данных для передачи в запросе, если требуется
}


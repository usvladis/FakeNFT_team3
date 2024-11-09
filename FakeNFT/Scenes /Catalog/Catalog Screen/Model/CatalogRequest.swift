//
//  CatalogRequest.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 21.10.2024.
//

import Foundation

// MARK: - CatalogRequest
/// Запрос для загрузки каталога NFT
struct CatalogRequest: NetworkRequest {
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections")
    }
    
    var dto: Dto?
}


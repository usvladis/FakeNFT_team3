//
//  EditOrderRequest.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 27.10.2024.
//

import Foundation

// MARK: - EditOrderRequest
/// Запрос для редактирования заказа
struct EditOrderRequest: NetworkRequest {
    
    // MARK: - Properties
    let newOrder: NewOrderModel?
    var httpMethod: HttpMethod = .put
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    
    var dto: Dto? {
        guard let data = newOrder else { return nil }
        var formData: [String: String] = [:]
        if !data.nfts.isEmpty {
            formData["nfts"] = data.nfts.joined(separator: ", ")
        }
        return FormDataDto(data: formData)
    }
}

// MARK: - NewOrderModel
/// Модель для создания нового заказа, содержащая список NFT
struct NewOrderModel: Encodable {
    var nfts: [String] // Идентификаторы NFT для добавления в заказ
}

// MARK: - FormDataDto
/// DTO для передачи данных в формате словаря
struct FormDataDto: Dto {
    let data: [String: String]
    
    func asDictionary() -> [String: String] {
        return data
    }
}


//
//  EditOrderRequest.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 27.10.2024.
//

import Foundation
struct EditOrderRequest: NetworkRequest {
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
struct NewOrderModel: Encodable {
    var nfts: [String]
}
struct FormDataDto: Dto {
    let data: [String: String]
    func asDictionary() -> [String: String] {
        return data
    }
}

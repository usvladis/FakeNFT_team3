//
//  Order.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 27.10.2024.
//

import Foundation

// MARK: - Order
/// Модель заказа, содержащая идентификатор и список NFT
struct Order: Codable {
    let id: String           // Идентификатор заказа
    let nfts: [String]       // Список идентификаторов NFT, включенных в заказ
}


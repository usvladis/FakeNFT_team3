//
//  Order.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 27.10.2024.
//

import Foundation

struct Order: Codable {
    let id: String
    let nfts: [String]
}

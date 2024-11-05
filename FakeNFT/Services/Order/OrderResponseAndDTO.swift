//
//  OrderResponseAndDTO.swift
//  FakeNFT
//
//  Created by Владислав Усачев on 31.10.2024.
//

import Foundation

struct OrderResponse: Decodable {
    let nfts: [String]
    let id: String
}

struct OrderDto: Dto {
    let nfts: [String]
    
    func asDictionary() -> [String : String] {
        [
            "nfts": nfts.joined(separator: ",")
        ]
    }
}

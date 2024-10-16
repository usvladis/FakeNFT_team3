//
//  NFTItem.swift
//  FakeNFT
//
//  Created by Владислав Усачев on 11.10.2024.
//

import UIKit

struct NFTItem {
    let image: UIImage
    let title: String
    let price: String
    let rating: Int
    
    static func mockData() -> [NFTItem] {
        return [
            NFTItem(image: UIImage(named: "april_nft")!, title: "April", price: "1,78 ETH", rating: 1),
            NFTItem(image: UIImage(named: "greena_nft")!, title: "Greena", price: "1,78 ETH", rating: 3),
            NFTItem(image: UIImage(named: "spring_nft")!, title: "Spring", price: "1,78 ETH", rating: 5)
        ]
    }
}

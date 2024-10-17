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
    let price: Double
    let rating: Int
    
    static func mockData() -> [NFTItem] {
        return [
            NFTItem(image: UIImage(named: "april_nft")!, title: "April", price: 1.55, rating: 1),
            NFTItem(image: UIImage(named: "greena_nft")!, title: "Greena", price: 2.78, rating: 3),
            NFTItem(image: UIImage(named: "spring_nft")!, title: "Spring", price: 14.88, rating: 5)
        ]
    }
}

//
//  NFTRowModel.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 10.10.2024.
//

import UIKit

//struct NFTRowModel {
//    let image: UIImage
//    let name: String
//    let count: Int
//}

struct NFTModelCatalog: Codable {
    let createdAt: String
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
    let id: String
}

typealias NFTsModelCatalog = [NFTModelCatalog]
typealias NFTsModelCatalogCompletion = (Result<NFTsModelCatalog, Error>) -> Void

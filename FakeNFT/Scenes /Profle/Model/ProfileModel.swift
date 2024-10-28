//
//  ProfileModel.swift
//  FakeNFT
//
//  Created by Дмитрий Жуков on 10/15/24.
//

import Foundation

// MARK: - ProfileModel
struct ProfileModel: Decodable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}

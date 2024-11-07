//
//  ProfilePutRequest.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 27.10.2024.
//

import Foundation

struct ProfilePutRequestK: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    var httpMethod: HttpMethod = .put
    var dto: Dto?
}

struct ProfileDtoObjectK: Dto {
    let likes: [String]
    let avatar: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case likes = "likes"
        case avatar = "avatar"
        case name = "name"
    }
    
    func asDictionary() -> [String : String] {
        [
            CodingKeys.likes.rawValue: likes.isEmpty ? "" : likes.joined(separator:", "),
            CodingKeys.avatar.rawValue: avatar,
            CodingKeys.name.rawValue: name
        ]
    }
}

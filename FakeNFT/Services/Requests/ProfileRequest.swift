//
//  ProfileRequest.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 27.10.2024.
//

import Foundation

struct ProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    var dto: Dto?
}

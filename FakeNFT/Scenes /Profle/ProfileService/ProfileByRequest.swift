//
//  ProfileByRequest.swift
//  FakeNFT
//
//  Created by Дмитрий Жуков on 10/28/24.
//

import Foundation

struct ProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)\(RequestConstants.profilePath)")
    }
    var dto: Dto?
}


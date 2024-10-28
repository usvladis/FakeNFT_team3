//
//  NftOrderRequest.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 28.10.2024.
//

import Foundation
struct NFTOrderRequest: NetworkRequest {
  var endpoint: URL? {
    URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
  }
  var dto: (any Dto)?
}

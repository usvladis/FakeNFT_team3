//
//  PaymentRequest.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 28.10.2024.
//

import Foundation

struct PaymentRequest: NetworkRequest {
  var endpoint: URL? {
    URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/1")
  }
  var dto: (any Dto)?
}

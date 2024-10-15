//
//  ProfileItem.swift
//  FakeNFT
//
//  Created by Дмитрий Жуков on 10/15/24.
//

import Foundation

struct ProfileItem {
    var categoryName: String
    var count: Int?

    init(categoryName: String, count: Int? = nil) {
        self.categoryName = categoryName
        self.count = count
    }
}

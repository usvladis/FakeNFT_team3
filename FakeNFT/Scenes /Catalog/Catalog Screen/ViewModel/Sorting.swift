//
//  SortEnum.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 21.10.2024.
//

import Foundation

final class SortOptionStorage {
    private let sortOptionKey = "sortOptionKey"
    
    func save(option: SortOption) {
        UserDefaults.standard.set(option.rawValue, forKey: sortOptionKey)
    }
    
    func retrieveSortOption() -> SortOption? {
        guard let rawValue = UserDefaults.standard.string(forKey: sortOptionKey),
              let option = SortOption(rawValue: rawValue) else {
            return nil
        }
        return option
    }
}

enum SortOption: String {
    case name = "sortByName"
    case count = "sortByCount"
}

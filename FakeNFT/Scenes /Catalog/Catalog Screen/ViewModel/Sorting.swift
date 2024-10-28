//
//  SortEnum.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 21.10.2024.
//

import Foundation

// MARK: - SortOptionStorage
/// Хранилище для сохранения и извлечения опции сортировки
final class SortOptionStorage {
    
    // MARK: - Properties
    private let sortOptionKey = "sortOptionKey"
    
    // MARK: - Public Methods
    /// Сохраняет выбранную опцию сортировки в UserDefaults
    func save(option: SortOption) {
        UserDefaults.standard.set(option.rawValue, forKey: sortOptionKey)
    }
    
    /// Извлекает сохранённую опцию сортировки из UserDefaults
    func retrieveSortOption() -> SortOption? {
        guard let rawValue = UserDefaults.standard.string(forKey: sortOptionKey),
              let option = SortOption(rawValue: rawValue) else {
            return nil
        }
        return option
    }
}

// MARK: - SortOption
/// Опции сортировки
enum SortOption: String {
    case name = "sortByName"   // Сортировка по имени
    case count = "sortByCount" // Сортировка по количеству
}


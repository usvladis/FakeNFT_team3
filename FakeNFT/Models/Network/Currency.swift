//
//  Currency.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 27.10.2024.
//

import Foundation

// MARK: - Currency
/// Модель валюты, содержащая основные атрибуты для представления валюты
struct Currency: Codable {
    let title: String       // Название валюты
    let name: String        // Краткое имя валюты
    let image: URL          // URL изображения валюты
    let id: String          // Уникальный идентификатор валюты
}


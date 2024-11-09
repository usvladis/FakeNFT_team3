//
//  Profile.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 27.10.2024.
//

import Foundation

// MARK: - Profile
/// Модель профиля пользователя, содержащая информацию о пользователе и его коллекциях
struct Profile: Codable {
    let name: String           // Имя пользователя
    let avatar: String         // URL аватара пользователя в виде строки
    let description: String    // Описание пользователя
    let website: String        // URL веб-сайта пользователя в виде строки
    let nfts: [String]         // Идентификаторы NFT, принадлежащих пользователю
    let likes: [String]        // Идентификаторы понравившихся NFT
    let id: String             // Уникальный идентификатор пользователя
}


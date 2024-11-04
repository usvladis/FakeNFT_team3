//
//  NFTRowModel.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 10.10.2024.
//

import UIKit

// MARK: - NFTModelCatalog
/// Модель каталога NFT, представляющая данные об одной коллекции
struct NFTModelCatalog: Codable {
    let createdAt: String          // Дата создания коллекции
    let name: String               // Название коллекции
    let cover: URL                 // URL-адрес обложки коллекции
    let nfts: [String]             // Массив идентификаторов NFT, входящих в коллекцию
    let description: String        // Описание коллекции
    let author: String             // Имя автора коллекции
    let id: String                 // Идентификатор коллекции
}

// MARK: - Type Aliases
typealias NFTsModelCatalog = [NFTModelCatalog]    // Тип для массива коллекций NFT
typealias NFTsModelCatalogCompletion = (Result<NFTsModelCatalog, Error>) -> Void  // Завершение запроса на загрузку каталога


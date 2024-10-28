//
//  NFTCellModel.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 12.10.2024.
//

import UIKit

// MARK: - NFTCellModel
/// Модель данных для отображения ячейки NFT
struct NFTCellModel {
    // MARK: - Properties
    let image: UIImage       // Изображение NFT
    let rating: Int          // Рейтинг NFT
    let name: String         // Название NFT
    let cost: Int            // Стоимость NFT
    let isLike: Bool         // Отметка "Нравится"
    let inCart: Bool         // Маркер добавления в корзину
}


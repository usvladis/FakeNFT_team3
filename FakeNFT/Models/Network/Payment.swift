//
//  Payment.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 27.10.2024.
//

import Foundation

// MARK: - Payment
/// Модель для представления результата оплаты
struct Payment: Codable {
    let success: Bool       // Статус успеха оплаты
    let orderId: String     // Идентификатор заказа
    let id: String          // Идентификатор транзакции
}


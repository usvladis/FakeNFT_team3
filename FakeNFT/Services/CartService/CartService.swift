//
//  CartService.swift
//  FakeNFT
//
//  Created by Владислав Усачев on 31.10.2024.
//

import Foundation

final class CartService {
    static let shared = CartService()
    
    private let cartKey = "cartNFTIds" // Ключ для хранения данных в UserDefaults
    private var nftIdsInCart: [String] = [] // Массив ID NFT, добавленных в корзину

    private init() {
        loadCartItems()
    }

    // Метод для добавления ID в корзину
    func addNFT(id: String) {
        // Проверяем, если ID уже в корзине, не добавляем повторно
        if !nftIdsInCart.contains(id) {
            nftIdsInCart.append(id)
            saveCartItems()
            print("NFT с ID \(id) добавлен в корзину")
        } else {
            print("NFT с ID \(id) уже в корзине")
        }
    }

    // Метод для удаления ID из корзины
    func removeNFT(id: String) {
        if let index = nftIdsInCart.firstIndex(of: id) {
            nftIdsInCart.remove(at: index)
            saveCartItems()
            print("NFT с ID \(id) удален из корзины")
        } else {
            print("NFT с ID \(id) не найден в корзине")
        }
    }
    
    // Метод для получения всех ID в корзине
    func getAllNFTIds() -> [String] {
        return nftIdsInCart
    }
    
    // MARK: - Private Methods
    
    // Метод для сохранения ID в UserDefaults
    private func saveCartItems() {
        UserDefaults.standard.set(nftIdsInCart, forKey: cartKey)
    }
    
    // Метод для загрузки ID из UserDefaults при инициализации
    private func loadCartItems() {
        if let savedIds = UserDefaults.standard.array(forKey: cartKey) as? [String] {
            nftIdsInCart = savedIds
        }
    }
}

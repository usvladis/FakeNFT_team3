//
//  CatalogViewModel.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 10.10.2024.
//

import UIKit

class CatalogViewModel {
    
    private var collections: [NFTRowForTableView] = []
    
    func fetchCollections(completion: @escaping () -> Void) {
        // Тут будет запрос к сервису для загрузки данных
        // После загрузки данных обновим массив Сollections
        guard let image = UIImage(named: "FrameMock") else {return}
        collections = [
            NFTRowForTableView(image: image, name: "Peach", count: 11),
            NFTRowForTableView(image: image, name: "Peach", count: 11),
            NFTRowForTableView(image: image, name: "Peach", count: 11),
            NFTRowForTableView(image: image, name: "Peach", count: 11),
            NFTRowForTableView(image: image, name: "Peach", count: 11)
        ]
        completion()
    }
    
    func numberOfCollections() -> Int {
        return collections.count
    }
    func collection(at index: Int) -> NFTRowForTableView {
        return collections[index]
    }
}

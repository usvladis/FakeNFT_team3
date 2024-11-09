//
//  CatalogViewModel.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 10.10.2024.
//

import UIKit

class CatalogViewModel {
    
<<<<<<< HEAD
    private var collections: [NFTRowForTableView] = []
    
    func fetchCollections(completion: @escaping () -> Void) {
        // Здесь будет запрос к сервису для загрузки данных
        // После загрузки данных обновим массив collections
        guard let image = UIImage(named: "peach") else {return}
        collections = [NFTRowForTableView(image: image, name: "Peach", count: 11), NFTRowForTableView(image: image, name: "Peach", count: 11), NFTRowForTableView(image: image, name: "Peach", count: 11), NFTRowForTableView(image: image, name: "Peach", count: 11), NFTRowForTableView(image: image, name: "Peach", count: 11)]
        completion()
    }
    // Методы для получения данных для UI
    func numberOfCollections() -> Int {
        return collections.count
    }
    func collection(at index: Int) -> NFTRowForTableView {
=======
    private var collections: [NFTRowModel] = []
    
    func fetchCollections(completion: @escaping () -> Void) {
        
        DispatchQueue.main.async {
            
        }
        guard let image = UIImage(named: "CollectionPreviewMock") else {return}
        collections = [NFTRowModel(image: image, name: "Peach", count: 11),
                       NFTRowModel(image: image, name: "Peach", count: 11),
                       NFTRowModel(image: image, name: "Peach", count: 11),
                       NFTRowModel(image: image, name: "Peach", count: 11),
                       NFTRowModel(image: image, name: "Peach", count: 11),
                       NFTRowModel(image: image, name: "Peach", count: 11)]
        completion()
    }
    
    func numberOfCollections() -> Int {
        return collections.count
    }
    
    func collection(at index: Int) -> NFTRowModel {
>>>>>>> Catalogue
        return collections[index]
    }
}

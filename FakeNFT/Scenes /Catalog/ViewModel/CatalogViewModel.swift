//
//  CatalogViewModel.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 10.10.2024.
//

import UIKit

class CatalogViewModel {
    
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
        return collections[index]
    }
}

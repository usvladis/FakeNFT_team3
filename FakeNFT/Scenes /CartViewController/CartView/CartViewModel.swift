//
//  CartViewModel.swift
//  FakeNFT
//
//  Created by Владислав Усачев on 01.11.2024.
//

import UIKit

final class CartViewModel {

    private(set) var nftItems: [NFTItem] = []
    private let nftService = SimpleNftService()
    private let cartService = CartService.shared
    
    var onItemsUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    var onLoadingStatusChanged: ((Bool) -> Void)?
    
    // Methods
    func loadNFTItems() {
        onLoadingStatusChanged?(true)
        let nftIds = cartService.getAllNFTIds()
        
        guard !nftIds.isEmpty else {
            nftItems.removeAll()
            onItemsUpdated?()
            onLoadingStatusChanged?(false)
            return
        }
        
        nftItems.removeAll()
        for id in nftIds {
            nftService.fetchNFT(by: id) { [weak self] result in
                switch result {
                case .success(let nft):
                    if let imageURLString = nft.images.first,
                       let url = URL(string: imageURLString) {
                        let nftItem = NFTItem(id: nft.id, imageURL: url, title: nft.name, price: nft.price, rating: nft.rating)
                        
                        self?.nftItems.append(nftItem)
                        self?.onItemsUpdated?()
                        self?.applySavedSortType()
                    }
                case .failure(let error):
                    self?.onError?(error)
                }
                self?.onLoadingStatusChanged?(false)
            }
        }
    }
    
    func deleteNFT(withId id: String) {
        if let index = nftItems.firstIndex(where: { $0.id == id }) {
            nftItems.remove(at: index)
            cartService.removeNFT(id: id)
            onItemsUpdated?()
            applySavedSortType()
        }
    }
    
    func getTotalPrice() -> String {
        let totalPrice = nftItems.reduce(0) { $0 + $1.price }
        return String(format: "%.2f ETH", totalPrice)
    }
    
    func getTotalNFTCount() -> String {
        return "\(nftItems.count) NFT"
    }
    
    func applySavedSortType() {
        let savedSortType = UserDefaults.standard.string(forKey: "selectedSortType") ?? "price"
        switch savedSortType {
        case "price": sortByPrice()
        case "rating": sortByRating()
        case "name": sortByName()
        default: sortByPrice()
        }
    }
    
    func sortByPrice() {
        nftItems.sort { $0.price < $1.price }
        UserDefaults.standard.set("price", forKey: "selectedSortType")
        onItemsUpdated?()
    }
    
    func sortByRating() {
        nftItems.sort { $0.rating > $1.rating }
        UserDefaults.standard.set("rating", forKey: "selectedSortType")
        onItemsUpdated?()
    }
    
    func sortByName() {
        nftItems.sort { $0.title < $1.title }
        UserDefaults.standard.set("name", forKey: "selectedSortType")
        onItemsUpdated?()
    }
}

//
//  MyNFTViewModel.swift
//  FakeNFT
//
//  Created by Дмитрий Жуков on 10/30/24.
//

import UIKit
import Kingfisher

final class MyNFTViewModel {
    
    // MARK: - Dependencies
    private let nftService: NftService
    
    // MARK: - Public Properties
    var nft: Nft? {
        didSet {
            nftsUpdated?()
        }
    }
    
    var nftImageUrl: String {
        return nft?.images.first ?? ""
    }
    
    var nftsUpdated: (() -> Void)?
    var nftsImageUpdate: ((String, UIImage?) -> Void)?
    
    // MARK: - Data for UIController
    var nfts: [Nft] = []
    var myNFT: [String]? = []
    var nftImages: [String: UIImage] = [:]
    
    // MARK: - Initializer
    init(nftService: NftService) {
        self.nftService = nftService
    }
    
    func configure(
        with viewModel: ProfileViewModel
    ) {
        viewModel.delegate = self
        viewModel.fetchNFTData()
    }
    
    // MARK: - Data Loading
    func loadNFTs(mynft: [String]) {
        nfts = []
        let dispatchGroup = DispatchGroup()
        
        for nftId in mynft {
            dispatchGroup.enter()
            nftService.loadNft(id: nftId) { [weak self] result in
                guard let self = self else { return }
                defer { dispatchGroup.leave() }
                
                switch result {
                case .success(let nft):
                    self.nfts.append(nft)
                    self.nft = nft
                    self.loadNFTImage(for: nft)
                    
                case .failure(let error):
                    print("Ошибка загрузки NFT с id \(nftId): \(error)")
                }
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.nftsUpdated?()
        }
    }
    
    func loadNFTImage(for nft: Nft) {
        guard let imageURL = URL(string: nftImageUrl) else { return }
        
        KingfisherManager.shared.retrieveImage(with: imageURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                self.nftImages[nft.id] = value.image
                
                if let index = self.nfts.firstIndex(where: { $0.id == nft.id }) {
                    self.nfts[index].name = self.extractNFTName(from: nftImageUrl) ?? nft.originalName
                }
                self.nftsImageUpdate?(nft.id, value.image)
                
            case .failure(let error):
                print("Ошибка загрузки изображения NFT: \(error)")
                self.nftsImageUpdate?(nft.id, nil)
            }
        }
    }
    
    func extractNFTName(
        from urlString: String
    ) -> String? {
        let pattern = #"\/([^\/]+)\/\d+\.png$"#
        let regex = try? NSRegularExpression(
            pattern: pattern,
            options: []
        )
        let nsString = urlString as NSString
        let results = regex?.firstMatch(
            in: urlString,
            options: [],
            range: NSRange(
                location: 0,
                length: nsString.length
            )
        )
        
        if let range = results?.range(
            at: 1
        ) {
            return nsString.substring(
                with: range
            )
        }
        return nil
    }
    
    func ratingImage(
        for nft: Nft
    ) -> UIImage? {
        let rating = min(max(nft.rating, 0), 5)
        return UIImage(named: "rating_\(rating)")
    }
    
    // MARK: - Sorting
    func sortByName() {
        nfts.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        nftsUpdated?()
    }
    
    func sortByRating() {
        nfts.sort { $0.rating > $1.rating }
        nftsUpdated?()
    }
    
    func sortByPrice() {
        nfts.sort { $0.price < $1.price }
        nftsUpdated?()
    }
}

extension MyNFTViewModel: ProfileViewModelDelegate {
    func didReceiveFavoriteNFT(
        favoriteNFT: [String]?
    ) {}
    
    func didReceiveProfileData(
        profileImageURL: String?,
        userName: String?,
        userDescription: String?,
        userWebsite: String?
    ) {}
    
    func didReceiveMyNFT(
        myNFT: [String]?
    ) {
        self.myNFT = myNFT
    }
}

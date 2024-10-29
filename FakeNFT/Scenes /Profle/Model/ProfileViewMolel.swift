//
//  ProfileViewMolel.swift
//  FakeNFT
//
//  Created by Дмитрий Жуков on 10/15/24.
//

import UIKit
import Kingfisher

final class ProfileViewModel {
    
    // MARK: - Dependencies
    private let profileService: ProfileServiceProtocol
    private let nftService: NftService
    private let nftStorage: NftStorage
    
    // MARK: - Public Properties
    var profile: ProfileModel? {
        didSet {
            profileUpdated?()
        }
    }
    var nft: Nft? {
        didSet {
            nftsUpdated?()
        }
    }
    
    var profileImageUrl: String {
        get {
            return profile?.avatar ?? ""
        }
        set {
            profile?.avatar = newValue
        }
    }
    
    var nftImageUrl: String {
            return nft?.images.first ?? ""
    }
    
    var userName: String {
        get {
            return profile?.name ?? ""
        }
        set {
            profile?.name = newValue
        }
    }
    
    var userDescription: String {
        get {
            return profile?.description ?? ""
        }
        set {
            profile?.description = newValue
        }
    }
    
    var userWebsite: String {
        get {
            return profile?.website ?? ""
        }
        set {
            profile?.website = newValue
        }
    }
   
    
    var profileUpdated: (() -> Void)?
    var profileImageUpdated: ((UIImage?) -> Void)?
    var nftsUpdated: (() -> Void)?
    var nftsImageUpdate: ((String, UIImage?) -> Void)?
    
    // MARK: - Data for UIController
    var items: [ProfileItem] = []
    var nfts: [Nft] = []
    var likedNFTs: [Nft] = []
    var myNFT: [String] = []
    var favoriteNFT: [String] = []
    var nftImages: [String: UIImage] = [:]
    
    // MARK: - Initializer
    init(profileService: ProfileServiceProtocol, nftService: NftService, nftStorage: NftStorage) {
        self.profileService = profileService
        self.nftService = nftService
        self.nftStorage = nftStorage
    }
    
    // MARK: - Data Loading
    func loadProfile() {
        profileService.loadProfile { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.profile = profile
                self.loadProfileImage()
                self.myNFT = profile.nfts
                self.favoriteNFT = profile.likes
                self.items = [
                    ProfileItem(
                        categoryName: localizedString(key: "myNFT"),
                        count: profile.nfts.count
                    ),
                    ProfileItem(
                        categoryName: localizedString(key: "favoriteNFT"),
                        count: profile.likes.count
                    ),
                    ProfileItem(
                        categoryName: localizedString(key: "aboutTheDeveloper")
                    )
                ]
                self.profileUpdated?()
            case .failure(let error):
                print("Ошибка загрузки профиля: \(error)")
            }
        }
    }
    
    func updateProfile(
        name: String,
        avatar: String,
        description: String,
        website: String,
        completion: @escaping (Result<ProfilePutResponse, Error>) -> Void
    ) {
        profileService.sendProfilePutRequest(
            param1: name,
            param2: avatar,
            param3: description,
            param4: website
        ) { result in
            switch result {
            case .success(let response):
                // Обновите локальные данные профиля, если нужно
                self.loadProfile()
                print("Обновление профиля завершено, вызываем profileUpdated.")
//                self.profileUpdated?() // Обновите UI
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadProfileImage() {
        guard let imageURL = URL(string: profileImageUrl) else {
            print("Некорректный URL: \(profileImageUrl)")
            return
        }
        KingfisherManager.shared.retrieveImage(with: imageURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                print("Изображение загружено: \(value.image)")
                self.profileImageUpdated?(value.image)
            case .failure(let error):
                print("Ошибка загрузки изображения: \(error)")
                if case .processorError(let reason) = error {
                    print("Ошибка процессора: \(reason)")
                }
                self.profileImageUpdated?(nil)
            }
        }
    }
    
    func loadLikedNFTs(likes: [String]) {
        likedNFTs = []
        let dispatchGroup = DispatchGroup()
        
        for nftId in likes {
            dispatchGroup.enter()
            nftService.loadNft(id: nftId) { [weak self] result in
                guard let self = self else { return }
                defer { dispatchGroup.leave() }
                switch result {
                case .success(let nft):
                    self.likedNFTs.append(nft)
                    self.nft = nft
                    self.loadNFTImage(for: nft, source: NFTSource.favoriteNFT)
                    
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
                    self.loadNFTImage(for: nft, source: NFTSource.myNFT)
                    
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
    
    func loadNFTImage(for nft: Nft, source: NFTSource) {
        guard let imageURL = URL(string: nftImageUrl) else { return }
        
        KingfisherManager.shared.retrieveImage(with: imageURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                print("Изображение NFT загружено")
                self.nftImages[nft.id] = value.image
                
                switch source {
                case .myNFT:
                    if let index = self.nfts.firstIndex(where: { $0.id == nft.id }) {
                        self.nfts[index].name = extractNFTName(from: nftImageUrl) ?? nft.originalName
                    }
                case .favoriteNFT:
                    if let index = self.likedNFTs.firstIndex(where: { $0.id == nft.id }) {
                        self.likedNFTs[index].name = extractNFTName(from: nftImageUrl) ?? nft.originalName
                    }
                }
                self.nftsImageUpdate?(nft.id, value.image)
                
            case .failure(let error):
                print("Ошибка загрузки изображения NFT: \(error)")
                self.nftsImageUpdate?(nft.id, nil)
            }
        }
    }
    
    func extractNFTName(from urlString: String) -> String? {
        let pattern = #"\/([^\/]+)\/\d+\.png$"#
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let nsString = urlString as NSString
        let results = regex?.firstMatch(in: urlString, options: [], range: NSRange(location: 0, length: nsString.length))
        
        if let range = results?.range(at: 1) {
            return nsString.substring(with: range)
        }
        return nil
    }
    
    func ratingImage(for nft: Nft) -> UIImage? {
        let rating = min(max(nft.rating, 0), 5)
        return UIImage(named: "rating_\(rating)")
    }
    
    // MARK: - Логика обработки нажатий на ячейки
    func didSelectItem(at index: Int) -> ProfileAction {
        switch index {
        case 0:
            return .navigateToMyNFTs
        case 1:
            return .navigateToFavorites
        case 2:
            return .openUserWebsite(url: userWebsite)
        default:
            return .none
        }
    }
    
    // MARK: - Сортировка
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

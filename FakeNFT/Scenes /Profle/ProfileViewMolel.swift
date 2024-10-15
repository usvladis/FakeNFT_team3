//
//  ProfileViewMolel.swift
//  FakeNFT
//
//  Created by Дмитрий Жуков on 10/15/24.
//

import UIKit

final class ProfileViewModel {
    
    // MARK: - Public Properties
    var profile: ProfileModel {
        didSet {
            profileUpdated?()
        }
    }
    
    var profileImage: String {
        return profile.profileImage
    }
    
    var userName: String {
        return profile.userName
    }
    
    var userDescription: String {
        return profile.userDescription
    }
    
    var userWebsite: String {
        return profile.userWebsite
    }
    
    var profileUpdated: (() -> Void)?

    // MARK: - Data for UITable
    var items: [ProfileItem] = []
    var myNFTNames = ["Piper","Archie","Zeus", "Lucky"]
    var favoriteNFTNames = ["Piper","Archie","Zeus", "Lucky"]
    
    // MARK: - Initializer
    init(profile: ProfileModel) {
        self.profile = profile
        self.items = [
            ProfileItem(categoryName: "Мои NFT", count: myNFTNames.count),
            ProfileItem(categoryName: "Избранные NFT", count: myNFTNames.count),
            ProfileItem(categoryName: "О разработчике")
        ]
    }
    
    // MARK: - Логика обработки нажатий на ячейки
    func didSelectItem(at index: Int) -> ProfileAction {
        switch index {
        case 0:
            return .navigateToMyNFTs
        case 1:
            return .navigateToFavorites
        case 2:
            return .openUserWebsite
        default:
            return .none
        }
    }
}


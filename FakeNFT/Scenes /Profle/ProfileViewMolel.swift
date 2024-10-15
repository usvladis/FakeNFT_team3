//
//  ProfileViewMolel.swift
//  FakeNFT
//
//  Created by Дмитрий Жуков on 10/15/24.
//

import UIKit

final class ProfileViewModel {
    
    // MARK: - Properties
    var profile: ProfileModel {
        didSet {
            profileUpdated?()
        }
    }
    
    // MARK: - Public Properties
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
    
    // Callback для обновления UI
        var profileUpdated: (() -> Void)?
    
    var myNFTNames = ["Piper","Archie","Zeus", "Lucky"]
    var favoriteNFTNames = ["Piper","Archie","Zeus", "Lucky"]
    
    // Данные для таблицы
    var items: [ProfileItem] = []
    
    // MARK: - Initializer
    init(profile: ProfileModel) {
        self.profile = profile
        self.items = [
            ProfileItem(categoryName: "Мои NFT", count: myNFTNames.count),
            ProfileItem(categoryName: "Избранные NFT", count: myNFTNames.count),
            ProfileItem(categoryName: "О разработчике")
        ]
    }
}


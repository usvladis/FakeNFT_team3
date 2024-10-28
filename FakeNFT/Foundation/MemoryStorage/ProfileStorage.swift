//
//  ProfileStorage.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 27.10.2024.
//

import Foundation

// MARK: - ProfileStorage Protocol
protocol ProfileStorage: AnyObject {
    func saveProfile(profile: Profile)
    func getProfile() -> Profile?
}

// MARK: - ProfileStorageImpl
/// Реализация хранения профиля с использованием синхронизации
final class ProfileStorageImpl: ProfileStorage {
    
    // MARK: - Properties
    private var profile: Profile?
    private let syncQueue = DispatchQueue(label: "sync-nft-queue")
    
    // MARK: - ProfileStorage Methods
    func saveProfile(profile: Profile) {
        syncQueue.async {
            self.profile = profile
        }
    }
    
    func getProfile() -> Profile? {
        syncQueue.sync {
            profile
        }
    }
}


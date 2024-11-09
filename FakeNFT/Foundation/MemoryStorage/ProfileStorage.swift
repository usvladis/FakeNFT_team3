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
/// Реализация хранения профиля с использованием NSLock для синхронизации
final class ProfileStorageImpl: ProfileStorage {
    
    // MARK: - Properties
    private var profile: Profile?
    private let mutex = NSLock()
    
    // MARK: - ProfileStorage Methods
    func saveProfile(profile: Profile) {
        mutex.lock()
        self.profile = profile
        mutex.unlock()
    }
    
    func getProfile() -> Profile? {
        mutex.lock()
        defer { mutex.unlock() }
        return profile
    }
}


//
//  ProfileServiceK.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 27.10.2024.
//

import Foundation

// MARK: - Type Aliases
typealias ProfileCompletionK = (Result<Profile, Error>) -> Void
typealias ProfilePutCompletionK = (Result<Profile, Error>) -> Void

// MARK: - ProfileServiceK Protocol
protocol ProfileServiceK {
    func loadProfile(completion: @escaping ProfileCompletionK)
    func updateProfile(
        likes: [String],
        avatar: String,
        name: String,
        completion: @escaping ProfilePutCompletionK
    )
}

// MARK: - ProfileServiceKImpl
/// Реализация сервиса для загрузки и обновления профиля
final class ProfileServiceKImplK: ProfileServiceK {
    
    // MARK: - Properties
    private let networkClient: NetworkClient
    private let storage: ProfileStorage
    
    // MARK: - Initializer
    init(networkClient: NetworkClient, storage: ProfileStorage) {
        self.networkClient = networkClient
        self.storage = storage
    }
    
    // MARK: - ProfileServiceK Methods
    func loadProfile(completion: @escaping ProfileCompletionK) {
        
        // Проверка, есть ли профиль в локальном хранилище
        if let profile = storage.getProfile() {
            completion(.success(profile))
            return
        }
        
        // Загрузка профиля через сеть
        let request = ProfileRequest()
        networkClient.send(request: request, type: Profile.self) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.storage.saveProfile(profile: profile)
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateProfile(
        likes: [String],
        avatar: String,
        name: String,
        completion: @escaping ProfilePutCompletionK
    ) {
        let dto = ProfileDtoObjectK(likes: likes, avatar: avatar, name: name)
        let request = ProfilePutRequestK(dto: dto)
        
        networkClient.send(request: request, type: Profile.self) { [weak self] result in
            switch result {
            case .success(let profileResponse):
                self?.storage.saveProfile(profile: profileResponse)
                completion(.success(profileResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


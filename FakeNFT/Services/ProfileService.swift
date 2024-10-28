//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 27.10.2024.
//

import Foundation

// MARK: - Type Aliases
typealias ProfileCompletion = (Result<Profile, Error>) -> Void
typealias ProfilePutCompletion = (Result<Profile, Error>) -> Void

// MARK: - ProfileService Protocol
protocol ProfileService {
    func loadProfile(completion: @escaping ProfileCompletion)
    func sendExamplePutRequest(
        likes: [String],
        avatar: String,
        name: String,
        completion: @escaping ProfilePutCompletion
    )
}

// MARK: - ProfileServiceImpl
/// Реализация сервиса для загрузки и обновления профиля
final class ProfileServiceImpl: ProfileService {
    
    // MARK: - Properties
    private let networkClient: NetworkClient
    private let storage: ProfileStorage
    
    // MARK: - Initializer
    init(networkClient: NetworkClient, storage: ProfileStorage) {
        self.networkClient = networkClient
        self.storage = storage
    }
    
    // MARK: - ProfileService Methods
    func loadProfile(completion: @escaping ProfileCompletion) {
        
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
    
    func sendExamplePutRequest(
        likes: [String],
        avatar: String,
        name: String,
        completion: @escaping ProfilePutCompletion
    ) {
        let dto = ProfileDtoObject(likes: likes, avatar: avatar, name: name)
        let request = ProfilePutRequest(dto: dto)
        
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


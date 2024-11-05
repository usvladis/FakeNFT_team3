//
//  SimpleNftService.swift
//  FakeNFT
//
//  Created by Владислав Усачев on 31.10.2024.
//

import Foundation

final class SimpleNftService {
    // Вставьте ваш личный токен здесь
    private let apiToken = "0dfc95a4-ad03-4021-8cdb-30d9d7f8252e"
    private let baseURL = "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1"
    
    // MARK: - Получение информации о NFT по ID
    func fetchNFT(by id: String, completion: @escaping (Result<Nft, Error>) -> Void) {
        let urlString = "\(baseURL)/nft/\(id)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(apiToken, forHTTPHeaderField: "X-Practicum-Mobile-Token")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }

            do {
                let nft = try JSONDecoder().decode(Nft.self, from: data)
                completion(.success(nft))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // MARK: - Отправка заказа
    func placeOrder(with nftIds: [String], completion: @escaping (Result<OrderResponse, Error>) -> Void) {
        let urlString = "\(baseURL)/orders/1"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue(apiToken, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        // Создаем тело запроса
        let bodyString = "nfts=\(nftIds.joined(separator: ","))"
        request.httpBody = bodyString.data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }

            do {
                let orderResponse = try JSONDecoder().decode(OrderResponse.self, from: data)
                completion(.success(orderResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

//
//  PaymentMethod.swift
//  FakeNFT
//
//  Created by Владислав Усачев on 11.10.2024.
//

import UIKit

struct PaymentMethod {
    let image: UIImage
    let name: String
    let shortName: String
    
    static func data() -> [PaymentMethod] {
        return [
            PaymentMethod(image: UIImage(named: "bitcoin")!, name: "Bitcoin", shortName: "BTC"),
            PaymentMethod(image: UIImage(named: "doge")!, name: "Dogecoin", shortName: "DOGE"),
            PaymentMethod(image: UIImage(named: "tether")!, name: "Tether", shortName: "USDT"),
            PaymentMethod(image: UIImage(named: "ape")!, name: "Apecoin", shortName: "APE"),
            PaymentMethod(image: UIImage(named: "solana")!, name: "Solana", shortName: "SOL"),
            PaymentMethod(image: UIImage(named: "etherium")!, name: "Ethereum", shortName: "ETH"),
            PaymentMethod(image: UIImage(named: "cardano")!, name: "Cardano", shortName: "ADA"),
            PaymentMethod(image: UIImage(named: "shiba")!, name: "Shiba Inu", shortName: "SHIB")
        ]
    }
}


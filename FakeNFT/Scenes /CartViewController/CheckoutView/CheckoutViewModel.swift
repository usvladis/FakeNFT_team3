//
//  CheckoutViewModel.swift
//  FakeNFT
//
//  Created by Владислав Усачев on 01.11.2024.
//

import UIKit

final class CheckoutViewModel {
    
    // Привязка данных для наблюдения из ViewController
    let paymentMethods: [PaymentMethod]
    let agreementText: String
    let payButtonText: String
    
    private let nftService = SimpleNftService()
    private let cartService = CartService.shared
    
    // Привязка для состояния выбранного метода оплаты
    private(set) var selectedPaymentMethodIndex = Observable<IndexPath?>(nil)
    
    // Состояние обработки результата оплаты
    var onPaymentSuccess: (() -> Void)?
    var onPaymentFailure: ((String) -> Void)?
    
    init() {
        self.paymentMethods = PaymentMethod.data()
        self.agreementText = localizedString(key: "warningUserAgreement")
        self.payButtonText = localizedString(key: "pay")
    }
    
    func selectPaymentMethod(at indexPath: IndexPath) {
        selectedPaymentMethodIndex.value = indexPath
    }
    
    func handlePayButton() {
        let nftIds = cartService.getAllNFTIds()
        nftService.placeOrder(with: nftIds) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.cartService.clearCart()
                    self?.onPaymentSuccess?()
                case .failure:
                    self?.onPaymentFailure?(localizedString(key: "paymentErrorAlertTitle"))
                }
            }
        }
    }
}

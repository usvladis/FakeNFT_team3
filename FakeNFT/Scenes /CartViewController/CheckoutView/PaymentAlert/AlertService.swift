//
//  AlertService.swift
//  FakeNFT
//
//  Created by Владислав Усачев on 31.10.2024.
//

import UIKit

final class AlertService {
    static func createAlert(title: String, retryHandler: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: localizedString(key: "cancel"), style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: localizedString(key: "retry"), style: .default) { _ in
            retryHandler()
        })
        
        return alert
    }
}

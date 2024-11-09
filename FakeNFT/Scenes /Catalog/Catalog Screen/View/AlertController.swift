//
//  AlertController.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 10.10.2024.
//

import UIKit

// MARK: - AlertController
final class AlertController: UIAlertController {
    
    // MARK: - Properties
    private var customDimmingColor: UIColor?
    
    // MARK: - Public Methods
    func setDimmingColor(_ color: UIColor) {
        customDimmingColor = color
    }
    
    // MARK: - Override Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let color = customDimmingColor, let dimmingView = view.superview?.subviews.first {
            dimmingView.backgroundColor = color
        }
    }
}


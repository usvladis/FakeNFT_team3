//
//  AlertController.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 10.10.2024.
//

import UIKit

final class AlertController: UIAlertController {
    
    private var customDimmingColor: UIColor?
    
    func setDimmingColor(_ color: UIColor) {
        customDimmingColor = color
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let color = customDimmingColor, let dimmingView = self.view.superview?.subviews.first {
            dimmingView.backgroundColor = color
        }
    }
}

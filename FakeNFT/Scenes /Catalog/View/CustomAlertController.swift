//
//  CustomAlertController.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 10.10.2024.
//

import UIKit

class CustomAlertControllerForSort: UIAlertController {
    
    private var customDimmingColor: UIColor?
    
    // Метод для настройки цвета затемнения
    func setDimmingColor(_ color: UIColor) {
        customDimmingColor = color
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Применяем кастомное затемнение
        if let color = customDimmingColor, let dimmingView = self.view.superview?.subviews.first {
            dimmingView.backgroundColor = color
        }
    }
}

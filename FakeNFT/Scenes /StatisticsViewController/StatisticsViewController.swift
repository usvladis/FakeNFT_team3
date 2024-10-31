//
//  StatisticsViewController.swift
//  FakeNFT
//
//  Created by Владислав Усачев on 09.10.2024.
//

import UIKit
import SwiftUI

// MARK: - Preview
struct StatisticsViewControllerPreview: PreviewProvider {
    static var previews: some View {
        StatisticsViewController().showPreview()
    }
}

final class StatisticsViewController: UIViewController {
    private let cartService = CartService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        cartService.addNFT(id: "a4edeccd-ad7c-4c7f-b09e-6edec02a812b")
        cartService.addNFT(id: "3434c774-0e0f-476e-a314-24f4f0dfed86")
        cartService.addNFT(id: "c14cf3bc-7470-4eec-8a42-5eaa65f4053c")
    }
}


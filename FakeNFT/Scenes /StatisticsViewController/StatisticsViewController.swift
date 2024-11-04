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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
}


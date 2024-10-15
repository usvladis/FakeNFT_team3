//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Владислав Усачев on 09.10.2024.
//

import UIKit
import SwiftUI

// MARK: - Preview
struct ProfileViewControllerPreview: PreviewProvider {
    static var previews: some View {
        ProfileViewController().showPreview()
    }
}

final class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
}



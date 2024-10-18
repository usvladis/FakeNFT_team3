//
//  FaviriteNFTViewController.swift
//  FakeNFT
//
//  Created by Дмитрий Жуков on 10/18/24.
//

import UIKit
import SwiftUI

// MARK: - Preview
struct FavoriteNFTViewControllerPreview: PreviewProvider {
    static var previews: some View {
        FavoriteNFTViewController().showPreview()
    }
}

class FavoriteNFTViewController: UIViewController {
    var viewModel: ProfileViewModel?
    private var nftItems: [String] = []
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        if let imageButton = UIImage(named: "back_button")?.withRenderingMode(.alwaysTemplate) {
            button.setImage(imageButton, for: .normal)
            button.tintColor = .buttonColor
            button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        }
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroudColor
        setupNavBar()
        showPlaceHolder()
    }
    
    //MARK: - Private Methods
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.title = "Избранные NFT"
        let customFont = UIFont.bodyBold
        let attributes: [NSAttributedString.Key: Any] = [
            .font: customFont,
            .foregroundColor: UIColor.buttonColor
        ]
        navigationController?.navigationBar.titleTextAttributes = attributes
    }
    
    @objc
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private func showPlaceHolder() {
        let backgroundView = PlaceHolderView(frame: view.frame)
        backgroundView.setupNoFavoriteNFTState()
        view.addSubview(backgroundView)
    }

}

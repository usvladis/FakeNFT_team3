//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Дмитрий Жуков on 10/18/24.
//

import UIKit

class MyNFTViewController: UIViewController {
    //MARK: - ViewModel
    var viewModel: ProfileViewModel?
    
    //MARK: - UI Elements
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
    
    private lazy var sortingButton: UIButton = {
        let button = UIButton()
        if let imageButton = UIImage(named: "filter_button")?.withRenderingMode(.alwaysTemplate) {
            button.setImage(imageButton, for: .normal)
            button.tintColor = .buttonColor
             button.addTarget(self, action: #selector(sortingButtonTapped), for: .touchUpInside)
        }
        button.widthAnchor.constraint(equalToConstant: 42).isActive = true
        button.heightAnchor.constraint(equalToConstant: 42).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - LifeCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroudColor
        setupNavBar()
    }
    
    //MARK: - Private Methods
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortingButton)
        navigationItem.title = "Мои NFT"
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
    
    @objc
    private func sortingButtonTapped(_ sender: UIButton) {
            showSortingAlert()
        }

        private func showSortingAlert() {
            let alertController = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
            
            alertController.addAction(UIAlertAction(title: "По цене", style: .default) { _ in
                print("Сортировка по цене выбрана")
            })

            alertController.addAction(UIAlertAction(title: "По рейтингу", style: .default) { _ in
                print("Сортировка по рейтингу выбрана")
            })

            alertController.addAction(UIAlertAction(title: "По названию", style: .default) { _ in
                print("Сортировка по названию выбрана")
            })
            alertController.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
}

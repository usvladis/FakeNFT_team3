//
//  SuccessPaymentViewController.swift
//  FakeNFT
//
//  Created by Владислав Усачев on 11.10.2024.
//

import UIKit

final class SuccessPaymentViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "success_label")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let successLabel: UILabel = {
        let label = UILabel()
        label.text = localizedString(key: "successPayment")
        label.textColor = .fontColor
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let returnButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(localizedString(key: "returnToCatalogButtonText"), for: .normal)
        button.backgroundColor = .buttonColor
        button.setTitleColor(.backgroudColor, for: .normal)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroudColor
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(imageView)
        view.addSubview(successLabel)
        view.addSubview(returnButton)
        
        returnButton.addTarget(self, action: #selector(returnToCatalog), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            successLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            successLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            successLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            
            returnButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            returnButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            returnButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            returnButton.heightAnchor.constraint(equalToConstant: 60),
            
            imageView.bottomAnchor.constraint(equalTo: returnButton.topAnchor, constant: -228),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 278),
            imageView.widthAnchor.constraint(equalToConstant: 278),
        ])
    }
    
    @objc
    private func returnToCatalog() {
        if shouldShowRateAlert() {
            showRateAppAlert()
        } else {
            navigateToCatalog()
        }
    }
    
    private func showRateAppAlert() {
        let alert = UIAlertController(
            title: localizedString(key: "rateAlertTitle"),
            message: localizedString(key: "rateAlertMessage"),
            preferredStyle: .alert
        )
        
        let rateAction = UIAlertAction(title: localizedString(key: "rateAlertOk"), style: .default) { _ in
            if let url = URL(string: Constants.rateAlertUrl) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            self.setUserRatedApp()
            self.navigateToCatalog()
        }
        
        let laterAction = UIAlertAction(title: localizedString(key: "rateAlertLater"), style: .cancel) { _ in
            self.incrementDeclineCounter()
            self.navigateToCatalog()
        }
        
        alert.addAction(rateAction)
        alert.addAction(laterAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func navigateToCatalog() {
        let tabBarViewController = TabBarController()
        tabBarViewController.modalPresentationStyle = .fullScreen
        present(tabBarViewController, animated: false)
    }
    
    private func setUserRatedApp() {
        UserDefaults.standard.set(true, forKey: "hasRatedApp")
    }
    
    private func incrementDeclineCounter() {
        var declineCounter = UserDefaults.standard.integer(forKey: "declineCounter")
        declineCounter += 1
        UserDefaults.standard.set(declineCounter, forKey: "declineCounter")
    }
    
    private func shouldShowRateAlert() -> Bool {
        let hasRatedApp = UserDefaults.standard.bool(forKey: "hasRatedApp")
        if hasRatedApp {
            return false
        }
        
        let declineCounter = UserDefaults.standard.integer(forKey: "declineCounter")
        
        if declineCounter == 0 {
            return true
        } else if declineCounter < 2 {
            incrementDeclineCounter()
            return false
        } else if declineCounter == 2 {
            return true
        } else {
            return false
        }
    }
}

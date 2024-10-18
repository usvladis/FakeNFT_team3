//
//  DeveloperWebViewController.swift
//  FakeNFT
//
//  Created by Дмитрий Жуков on 10/18/24.
//

import UIKit
import WebKit

final class AboutDeveloperViewController: UIViewController {
    // MARK: - UI Elements
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
    
    // MARK: - Web Elements
    var urlString: String?
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: self.view.bounds)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    // MARK: - Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadURL()
    }
    
    // MARK: - Private Methods
    @objc
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func loadURL() {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            print("Некорректный URL")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

// MARK: - ViewConfigurable
extension AboutDeveloperViewController: ViewConfigurable {
    func addSubviews() {
        view.addSubview(webView)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupView() {
        view.backgroundColor = .backgroudColor
        setupNavBar()
        configureView()
    }
}

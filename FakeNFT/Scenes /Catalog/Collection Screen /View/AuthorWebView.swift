//
//  AuthorWebView.swift
//  FakeNFT
//
//  Created by Кирилл Марьясов on 21.10.2024.
//

import UIKit
import WebKit

// MARK: - AuthorWebViewController
final class AuthorWebViewController: UIViewController {
    
    // MARK: - UI Elements
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Initializers
    init(url: URL) {
        super.init(nibName: nil, bundle: nil)
        webView.navigationDelegate = self
        load(url: url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        setupConstraints()
        configureWebViewBackButton()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        configureWebViewBackButton()
    }
    
    // MARK: - Setup Methods
    private func addSubviews() {
        view.addSubview(webView)
        view.addSubview(loadingIndicator)
    }
    
    private func configureWebViewBackButton() {
        let backButtonImage = UIImage(named: "back_button")
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(didTapWebViewBackButton))
        
        backButton.tintColor = .label
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Load Web Content
    private func load(url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
        loadingIndicator.startAnimating()
    }
    
    // MARK: - Actions
    @objc private func didTapWebViewBackButton() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - WKNavigationDelegate
extension AuthorWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadingIndicator.stopAnimating()
    }
}



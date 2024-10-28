//
//  WebViewViewController.swift
//  FakeNFT
//
//  Created by Владислав Усачев on 18.10.2024.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController, WKNavigationDelegate {
    
    private var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupWebView()
        setupLoadingIndicator()
        
        if let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse/") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    private func setupNavigationBar() {
        
        view.backgroundColor = .backgroudColor
        
        navigationController?.navigationBar.backgroundColor = .backgroudColor
        navigationController?.navigationBar.tintColor = .backgroudColor
        let backButton = UIBarButtonItem(image: UIImage(named: "back_button"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .buttonColor
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupWebView() {
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        webView.navigationDelegate = self
    }
    
    private func setupLoadingIndicator() {
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc
    private func backButtonTapped() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            dismiss(animated: true)
        }
    }
    
    // MARK: - WKNavigationDelegate Methods
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        loadingIndicator.stopAnimating()
        print("Failed to load page: \(error.localizedDescription)")
    }
}

//
//  TabBarViewController.swift
//  FakeNFT
//
//  Created by Владислав Усачев on 09.10.2024.
//

import UIKit

class TabBarViewController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        tabBar.unselectedItemTintColor = .buttonColor
    }
    
    private func configureTabBar() {
        let profileViewController = ProfileViewController()
        let catalogViewController = CatalogViewController()
        let cartViewController = CartViewController()
        let statisticsViewController = StatisticsViewController()
        
        profileViewController.tabBarItem = UITabBarItem(
            title:  NSLocalizedString("profile", comment: ""),
            image: UIImage(named: "profile_tab"),
            selectedImage: nil
        )
        
        catalogViewController.tabBarItem = UITabBarItem(
            title:  NSLocalizedString("catalog", comment: ""),
            image: UIImage(named: "catalog_tab"),
            selectedImage: nil
        )
        
        cartViewController.tabBarItem = UITabBarItem(
            title:  NSLocalizedString("cart", comment: ""),
            image: UIImage(named: "cart_tab"),
            selectedImage: nil
        )
        
        statisticsViewController.tabBarItem = UITabBarItem(
            title:  NSLocalizedString("statistics", comment: ""),
            image: UIImage(named: "stats_tab"),
            selectedImage: nil
        )
        
        let cartNavigationViewController = UINavigationController(rootViewController: cartViewController)
        
        
        setViewControllers([profileViewController, catalogViewController, cartNavigationViewController, statisticsViewController], animated: true)
    }
}

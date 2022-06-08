//
//  TabbarAssembly.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 06.06.2022.
//

import UIKit

enum TabbarAssembly {
    static func build() -> UITabBarController {
        
        let allCoinsList = UINavigationController(rootViewController: MainModuleBuilder().build())
        let portfolio = UINavigationController(rootViewController: PortfolioViewController())
        
        let tabBar = UITabBarController()
        tabBar.tabBar.backgroundColor = .clear
        tabBar.setViewControllers([allCoinsList, portfolio], animated: true)
        allCoinsList.tabBarItem = UITabBarItem(title: "Live Prices", image: UIImage(systemName: "square.3.stack.3d"), tag: 0)
        portfolio.tabBarItem = UITabBarItem(title: "Your Portfolio", image: UIImage(systemName: "menucard"), tag: 1)
        tabBar.tabBar.tintColor = UIColor.theme.greenColor
        tabBar.tabBar.unselectedItemTintColor = UIColor.theme.secondaryColor
        return tabBar
    }
}

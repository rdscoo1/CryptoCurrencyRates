//
//  AppDelegate.swift
//  CryptoCurrencyRates
//
//  Created by Roman Khodukin on 10/27/20.
//

import UIKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.rootViewController = createTabBar()
        window?.makeKeyAndVisible()
        
        CoreDataService.shared.applicationDocumentsDirectory()
        
        setenv("CFNETWORK_DIAGNOSTICS", "3", 1)
        
        return true
    }
    
    func createCryptoCurrenciesNC() -> UINavigationController {
        let cryptoVC = CryptoCurrenciesViewController()
        cryptoVC.title = "Currencies List"
        cryptoVC.tabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 0)
        cryptoVC.tabBarItem.setValue("List", forKey: "internalTitle")
        let navigationController = UINavigationController(rootViewController: cryptoVC)
        navigationController.navigationBar.prefersLargeTitles = true

        return navigationController
    }
    
    func createMoreNavController() -> UINavigationController {
        let moreVC = MoreViewController()
        moreVC.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 0)
        let navigationController = UINavigationController(rootViewController: moreVC)

        return navigationController
    }
    
    func createTabBar() -> UITabBarController {
        let tabbar = UITabBarController()
        tabbar.viewControllers = [createCryptoCurrenciesNC(), createMoreNavController()]
        return tabbar
    }
}

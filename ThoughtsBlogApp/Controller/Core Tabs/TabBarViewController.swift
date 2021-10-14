//
//  TabBarViewController.swift
//  ThoughtsBlogApp
//
//  Created by Stefan Dojcinovic on 14.10.21..
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpControllers()
    }
    
    private func setUpControllers() {
        
        let homeVC = HomeViewController()
        homeVC.title = "Home"
        homeVC.navigationItem.largeTitleDisplayMode = .always
        
        let profileVC = ProfileViewController()
        profileVC.title = "Profile"
        profileVC.navigationItem.largeTitleDisplayMode = .always
        
        let navVC1 = UINavigationController(rootViewController: homeVC)
        navVC1.navigationBar.prefersLargeTitles = true
        navVC1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        
        let navVC2 = UINavigationController(rootViewController: profileVC)
        navVC2.navigationBar.prefersLargeTitles = true
        navVC2.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 1)
        
        setViewControllers([navVC1, navVC2], animated: true)
    }
}

//
//  ProfileViewController.swift
//  ThoughtsBlogApp
//
//  Created by Stefan Dojcinovic on 14.10.21..
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSignOut))
    }

    @objc private func didTapSignOut() {
        let alert = UIAlertController(title: "Sign Out",
                                      message: "Do you wish to sign out?",
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
            AuthManager.shared.signOut { [weak self] success in
                guard let self = self else { return }
                if success {
                    DispatchQueue.main.async {
                        let vc = SignInViewController()
                        vc.navigationItem.largeTitleDisplayMode = .always
                        
                        let navVC = UINavigationController(rootViewController: vc)
                        navVC.navigationBar.prefersLargeTitles = true
                        navVC.modalPresentationStyle = .fullScreen
                        self.present(navVC, animated: true, completion: nil)
                    }
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}


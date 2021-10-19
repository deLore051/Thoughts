//
//  ViewController.swift
//  ThoughtsBlogApp
//
//  Created by Stefan Dojcinovic on 14.10.21..
//

import UIKit

class HomeViewController: UIViewController {

    private let composeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.setImage(
            UIImage(
                systemName: "square.and.pencil",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .medium))
            , for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 40
        button.layer.shadowColor = UIColor.label.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 10
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(composeButton)
        composeButton.addTarget(self, action: #selector(didTapComposeButton), for: .touchUpInside)
    }

    @objc private func didTapComposeButton() {
        composeButton.tapEffect(sender: composeButton)
        let vc = CreateNewPostViewController()
        vc.title = "Create Post"
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        composeButton.frame = CGRect(x: view.frame.width - 100,
                                     y: view.frame.height - 100 - view.safeAreaInsets.bottom,
                                     width: 80,
                                     height: 80)
    }

}


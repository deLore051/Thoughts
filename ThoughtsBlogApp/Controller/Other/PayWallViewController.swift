//
//  PayWallViewController.swift
//  ThoughtsBlogApp
//
//  Created by Stefan Dojcinovic on 14.10.21..
//

import UIKit

class PayWallViewController: UIViewController {

    private let header = PayWallHeaderView()
    private let heroView = PayWallDescriptionView()
    
    // Pricing and product info
    // Call to action buttons
    private let subscribeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Subscribe", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .medium)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()
    
    private let restoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("Restore Purchases", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .medium)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        button.layer.masksToBounds = true
        return button
    }()
    
    // Terms of Service
    private let termsView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.textAlignment = .center
        textView.font = .systemFont(ofSize: 14)
        textView.textColor = .secondaryLabel
        textView.text = "This is auto-renewable subscription. It will be charged to your iTunes account before each pay period you can cancel any time by going into your Settings > Subscriptions. Restore Purchases if perviously subscribed. "
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Premium Toughts"
        view.backgroundColor = .systemBackground
        view.addSubview(header)
        view.addSubview(subscribeButton)
        view.addSubview(restoreButton)
        view.addSubview(termsView)
        view.addSubview(heroView)
        setUpCloseButton()
        setUpButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        header.frame = CGRect(x: 0,
                              y: view.safeAreaInsets.top,
                              width: view.width,
                              height: view.height / 4)
        
        termsView.frame = CGRect(x: 10,
                                 y: view.height - 100,
                                 width: view.width - 20,
                                 height: 100)
        
        restoreButton.frame = CGRect(x: 20,
                                     y: view.height - 175,
                                     width: view.width - 40,
                                     height: 50)
        
        subscribeButton.frame = CGRect(x: 20,
                                       y: view.height - 235,
                                       width: view.width - 40,
                                       height: 50)
        
        heroView.frame = CGRect(x: 0,
                                y: header.bottom,
                                width: view.width,
                                height: subscribeButton.top - header.height - view.safeAreaInsets.top)
    }
    
    private func setUpCloseButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setUpButtons() {
        subscribeButton.addTarget(self, action: #selector(didTapSubscribe), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(didTapRestore), for: .touchUpInside)
    }
    
    @objc private func didTapSubscribe() {
        // RevenueCat
    }
    
    @objc private func didTapRestore() {
        
    }
}

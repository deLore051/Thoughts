//
//  SignInViewController.swift
//  ThoughtsBlogApp
//
//  Created by Stefan Dojcinovic on 14.10.21..
//

import UIKit

class SignInViewController: UIViewController {
    
    // Header view
    private let headerView = SignInHeaderView()
    
    // Email field
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .emailAddress
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 50))
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.placeholder = "Email Address"
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        return textField
    }()
    
    // Password field
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 50))
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        return textField
    }()
    
    // Sign In button
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 26, weight: .medium)
        button.layer.masksToBounds = true
        return button
    }()
    
    // Create Account
    private let CreateAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 26, weight: .medium)
        button.layer.masksToBounds = true
        button.layer.borderWidth = 2
        button.layer.borderColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Sign In"
        
        view.addSubview(headerView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(CreateAccountButton)
        
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        CreateAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let width: CGFloat = view.width - 40
        let height: CGFloat = 50
        
        headerView.frame = CGRect(x: 0,
                                  y: view.safeAreaInsets.top,
                                  width: view.width,
                                  height: view.height / 4)
        
        emailTextField.frame = CGRect(x: 20,
                                      y: headerView.bottom + 10,
                                      width: width,
                                      height: height)
        emailTextField.layer.cornerRadius = height / 2
        
        passwordTextField.frame = CGRect(x: 20,
                                         y: emailTextField.bottom + 20,
                                         width: width,
                                         height: height)
        passwordTextField.layer.cornerRadius = height / 2
        
        signInButton.frame = CGRect(x: 20,
                                    y: passwordTextField.bottom + 50,
                                    width: width,
                                    height: height)
        signInButton.layer.cornerRadius = height / 2
        
        CreateAccountButton.frame = CGRect(x: 20,
                                           y: signInButton.bottom + 20,
                                           width: width,
                                           height: height)
        CreateAccountButton.layer.cornerRadius = height / 2
        
    }
    
    @objc private func didTapSignIn() {
        signInButton.tapEffect(sender: signInButton)
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else { return }
        
        AuthManager.shared.signIn(email: email, password: password) { [weak self] success in
            guard let self = self else { return }
            if success {
                DispatchQueue.main.async {
                    let vc = TabBarViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            } else {
                print("Sign in failed.")
            }
        }
    }
    
    @objc private func didTapCreateAccount() {
        CreateAccountButton.tapEffect(sender: CreateAccountButton)
        let vc = SignUpViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

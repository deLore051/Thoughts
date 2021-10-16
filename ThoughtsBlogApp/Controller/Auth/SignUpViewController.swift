//
//  SignUpViewController.swift
//  ThoughtsBlogApp
//
//  Created by Stefan Dojcinovic on 14.10.21..
//

import UIKit

class SignUpViewController: UIViewController {

    // Header view
    private let headerView = SignInHeaderView()
    
    // Username field
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 50))
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.placeholder = "Username"
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        return textField
    }()
    
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
    
    // Sign Un button
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 26, weight: .medium)
        button.layer.masksToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(headerView)
        view.addSubview(usernameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signUpButton)
        
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let width: CGFloat = view.width - 40
        let height: CGFloat = 50
        
        headerView.frame = CGRect(x: 0,
                                  y: view.safeAreaInsets.top,
                                  width: view.width,
                                  height: view.height / 4)
        
        
        usernameTextField.frame = CGRect(x: 20,
                                         y: headerView.bottom + 10,
                                         width: width,
                                         height: height)
        usernameTextField.layer.cornerRadius = height / 2
        
        emailTextField.frame = CGRect(x: 20,
                                      y: usernameTextField.bottom + 20,
                                      width: width,
                                      height: height)
        emailTextField.layer.cornerRadius = height / 2
        
        passwordTextField.frame = CGRect(x: 20,
                                         y: emailTextField.bottom + 20,
                                         width: width,
                                         height: height)
        passwordTextField.layer.cornerRadius = height / 2
        
        signUpButton.frame = CGRect(x: 20,
                                    y: passwordTextField.bottom + 50,
                                    width: width,
                                    height: height)
        signUpButton.layer.cornerRadius = height / 2
    }
    
    @objc private func didTapSignUp() {
        signUpButton.tapEffect(sender: signUpButton)
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let username = usernameTextField.text, !username.isEmpty else { return }
        
        // Create User
        AuthManager.shared.signUp(email: email, password: password) { [weak self] success in
            guard let self = self else { return }
            if success {
                // Update database
                let newUser = User(username: username, email: email, profilePictureURL: nil)
                DatabaseManager.shared.insert(user: newUser) { inserted in
                    guard inserted else {
                        return
                    }
                }
                DispatchQueue.main.async {
                    let vc = TabBarViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            } else {
                print("Sign up failed.")
            }
        }
    }
}

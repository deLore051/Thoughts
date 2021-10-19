//
//  CreateNewPostViewController.swift
//  ThoughtsBlogApp
//
//  Created by Stefan Dojcinovic on 14.10.21..
//

import UIKit

class CreateNewPostViewController: UIViewController {
    
    // Title field
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.leftViewMode = .always
        textField.placeholder = "Title"
        textField.textAlignment = .center
        textField.backgroundColor = .secondarySystemBackground
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 25
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        return textField
    }()
    
    // Image heade
    private let headerImageView: UIImageView = {
        let imageVIew = UIImageView()
        imageVIew.contentMode = .scaleAspectFill
        imageVIew.isUserInteractionEnabled = true
        imageVIew.image = UIImage(systemName: "photo")
        imageVIew.backgroundColor = .secondarySystemBackground
        imageVIew.clipsToBounds = true
        imageVIew.layer.cornerRadius = 20
        imageVIew.layer.borderColor = UIColor.systemBlue.cgColor
        imageVIew.layer.borderWidth = 2
        return imageVIew
    }()
    
    // TextView for the post
    private let postContentTextField: UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.font = .systemFont(ofSize: 22)
        textView.backgroundColor = .secondarySystemBackground
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 20
        textView.layer.borderColor = UIColor.systemBlue.cgColor
        textView.layer.borderWidth = 2
        return textView
    }()
    
    private var selectedHeaderImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpNavBarButtons()
        view.addSubview(titleTextField)
        view.addSubview(headerImageView)
        view.addSubview(postContentTextField)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapHeader))
        headerImageView.addGestureRecognizer(tap)
    }
    
    @objc private func didTapHeader() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    
    private func setUpNavBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .done,
            target: self,
            action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Post",
            style: .done,
            target: self,
            action: #selector(didTapPost))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let size: CGFloat = view.width - 40
        
        titleTextField.frame = CGRect(x: 20,
                                      y: view.safeAreaInsets.top + 10,
                                      width: size,
                                      height: 50)
        
        headerImageView.frame = CGRect(x: 20,
                                       y: titleTextField.bottom + 5,
                                       width: size,
                                       height: 200)
        
        postContentTextField.frame = CGRect(x: 20,
                                            y: headerImageView.bottom + 5,
                                            width: size,
                                            height: view.height - view.safeAreaInsets.top - 300)
        
    }

    
    @objc private func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapPost() {
        guard let title = titleTextField.text, !title.trimmingCharacters(in: .whitespaces).isEmpty,
              let body = postContentTextField.text, !body.trimmingCharacters(in: .whitespaces).isEmpty,
              let email = UserDefaults.standard.string(forKey: "email"),
              let headerImage = selectedHeaderImage else {
            let alert = UIAlertController(title: "Enter Post Details",
                                          message: "Please fill all the fields before posting an article",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        let postID = UUID().uuidString
        
        // Upload header image
        StorageManager.shared.uploadBlogHeaderImage(
            for: email,
            image: headerImage,
            postID: postID) { success in
            guard success else { return }
            StorageManager.shared.downloadUrlForPostHeader(email: email, postID: postID) { url in
                guard let headerURL = url else {
                    print("Failed to upload url for header")
                    return
                }
                let post = BlogPost(identifier: UUID().uuidString,
                                    title: title,
                                    date: Date().timeIntervalSince1970,
                                    headerImageURL: headerURL,
                                    text: body)
                
                DatabaseManager.shared.insert(blogPost: post, email: email) { [weak self] success in
                    guard let self = self, success else {
                        print("Failed to post new blog article!")
                        return
                    }
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
}



extension CreateNewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        selectedHeaderImage = image
        headerImageView.image = image
    }
    
}

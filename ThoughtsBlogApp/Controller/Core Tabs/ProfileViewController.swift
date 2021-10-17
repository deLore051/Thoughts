//
//  ProfileViewController.swift
//  ThoughtsBlogApp
//
//  Created by Stefan Dojcinovic on 14.10.21..
//

import UIKit

class ProfileViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    let currentEmail: String
    var user: User?
    private var posts: [BlogPost] = []
    
    init(currentEmail: String) {
        self.currentEmail = currentEmail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Profile"
        fetchProfileData()
        setUpSignOutButton()
        setUpTable()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setUpTableHeader()
    }
    
    private func setUpTableHeader(with profilePhotoReference: String? = nil,
                                  username: String? = nil) {
        let headerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: view.width,
                                              height: view.width / 1.5))
        headerView.backgroundColor = .systemBlue
        headerView.isUserInteractionEnabled = true
        tableView.tableHeaderView = headerView
        headerView.clipsToBounds = true
        
        // Profile picture
        let profilePhoto: UIImageView = {
            let imageView = UIImageView(image: UIImage(systemName: "person.circle"))
            imageView.tintColor = .white
            imageView.contentMode = .scaleAspectFill
            imageView.frame = CGRect(x: (view.width - (view.width / 3)) / 2 ,
                                     y: (headerView.height - (view.width / 3)) / 5,
                                     width: view.width / 3,
                                     height: view.width / 3)
            imageView.layer.borderWidth = 2
            imageView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = view.width / 6
            return imageView
        }()
        
        // Username
        let usernameLabel: UILabel = {
            let label = UILabel(frame: CGRect(x: 20,
                                              y: profilePhoto.bottom + 10,
                                              width: view.width - 40,
                                              height: 40))
            label.textAlignment = .center
            label.textColor = .white
            label.numberOfLines = 1
            label.font = .systemFont(ofSize: 26, weight: .medium)
            return label
        }()
        
        // Email
        let emailLabel: UILabel = {
            let label = UILabel(frame: CGRect(x: 20,
                                              y: usernameLabel.bottom,
                                              width: view.width - 40,
                                              height: 40))
            label.textAlignment = .center
            label.textColor = .white
            label.numberOfLines = 1
            label.font = .systemFont(ofSize: 20, weight: .medium)
            return label
        }()
        
        profilePhoto.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePhoto))
        profilePhoto.addGestureRecognizer(tap)
        
        if let username = username {
            usernameLabel.text = username
            emailLabel.text = currentEmail
        }
        
        if let reference = profilePhotoReference {
            StorageManager.shared.downloadUrlForProfilePicture(path: reference) { url in
                guard let url = url else { return }
                let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                    guard let data = data else { return }
                    DispatchQueue.main.async {
                        profilePhoto.image = UIImage(data: data)
                    }
                }
                task.resume()
            }
            
        }
        
        headerView.addSubview(profilePhoto)
        headerView.addSubview(usernameLabel)
        headerView.addSubview(emailLabel)
    }
    
    @objc private func didTapProfilePhoto() {
        guard let myEmail = UserDefaults.standard.string(forKey: "email"),
              myEmail == currentEmail else { return }
        
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    private func setUpSignOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSignOut))
    }
    
    private func fetchProfileData() {
        DatabaseManager.shared.getUser(email: currentEmail) { [weak self] user in
            guard let self = self, let user = user else { return }
            self.user = user
            DispatchQueue.main.async {
                self.setUpTableHeader(with: user.profilePictureReference,
                                      username: user.username)
            }
        }
    }
    
    private func fetchPosts() {
        
    }

    /// Sign out
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

//MARK: - UITableViewDataSource_Delegate

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Blog post goes here"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ViewPostViewController()
        vc.title = posts[indexPath.row].title
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - UIImagePickerControllerDelegate_UINavigationControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        StorageManager.shared.uploadUserProfilePicture(
            email: currentEmail,
            image: image) { [weak self] success in
            guard let self = self else { return }
            if success {
                DatabaseManager.shared.updateProfilePhoto(email: self.currentEmail) { updated in
                    guard updated else { return }
                    DispatchQueue.main.async {
                        self.fetchProfileData()
                    }
                }
            }
        }
    }
}

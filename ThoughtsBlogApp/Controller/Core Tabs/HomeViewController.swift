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
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PostPreviewTableViewCell.self,
                           forCellReuseIdentifier: PostPreviewTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private var posts: [BlogPost] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(composeButton)
        composeButton.addTarget(self, action: #selector(didTapComposeButton), for: .touchUpInside)
        tableView.delegate = self
        tableView.dataSource = self
        fetchPosts()
    }

    @objc private func didTapComposeButton() {
        composeButton.tapEffect(sender: composeButton)
        let vc = CreateNewPostViewController()
        vc.title = "Create Post"
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
    }
    
    private func fetchPosts() {
        DatabaseManager.shared.getAllPosts { [weak self] posts in
            guard let self = self else { return }
            self.posts = posts
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        composeButton.frame = CGRect(x: view.frame.width - 100,
                                     y: view.frame.height - 100 - view.safeAreaInsets.bottom,
                                     width: 80,
                                     height: 80)
    }

}

//MARK: - UITableViewDataSource_Delegate

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PostPreviewTableViewCell.identifier,
                for: indexPath) as? PostPreviewTableViewCell else { return UITableViewCell() }
        cell.configureCell(with: .init(title: post.title, imageURL: post.headerImageURL))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard InAppPurchaseManager.shared.canViewPost else {
            let vc = PayWallViewController()
            present(vc, animated: true, completion: nil)
            return
        }
        
        let vc = ViewPostViewController(post: posts[indexPath.row])
        vc.title = "Post"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

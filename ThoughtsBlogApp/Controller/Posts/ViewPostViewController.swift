//
//  ViewPostViewController.swift
//  ThoughtsBlogApp
//
//  Created by Stefan Dojcinovic on 14.10.21..
//

import UIKit

class ViewPostViewController: UIViewController {

    private let post: BlogPost
    private let isOwnedByCurrentUser: Bool
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(PostHeaderTableViewCell.self,
                           forCellReuseIdentifier: PostHeaderTableViewCell.identifier)
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    init(post: BlogPost, isOwnedByCurrentUser: Bool = false) {
        self.post = post
        self.isOwnedByCurrentUser = isOwnedByCurrentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        if !isOwnedByCurrentUser {
            InAppPurchaseManager.shared.logPostViewed()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

//MARK: - UITableViewDataSource_Delegate

extension ViewPostViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        switch index {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectionStyle = .none
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = post.title
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = .systemFont(ofSize: 22, weight: .medium)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: PostHeaderTableViewCell.identifier,
                    for: indexPath) as? PostHeaderTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.configureCell(with: .init(imageURL: post.headerImageURL))
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectionStyle = .none
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = post.text
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.font = .systemFont(ofSize: 18)
            return cell
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let index = indexPath.row
        switch index {
        case 0:
            return 70
        case 1:
            return 200
        case 2:
            return UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
        }
    }
    
}

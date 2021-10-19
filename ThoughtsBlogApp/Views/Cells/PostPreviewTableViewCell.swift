//
//  PostPreviewTableViewCell.swift
//  ThoughtsBlogApp
//
//  Created by Stefan Dojcinovic on 19.10.21..
//

import UIKit

class PostPreviewTableViewCellViewModel {
    let title: String
    let imageURL: URL?
    var imageData: Data?
    
    init(title: String, imageURL: URL?) {
        self.title = title
        self.imageURL = imageURL
    }
}

class PostPreviewTableViewCell: UITableViewCell {
    
    static let identifier = "PostPreviewTableViewCell"
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let postTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        addSubview(postImageView)
        addSubview(postTitleLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size: CGFloat = contentView.height - 10
        
        postImageView.frame = CGRect(x: safeAreaInsets.left + 5,
                                     y: 5,
                                     width: size,
                                     height: size)
        
        postTitleLabel.frame = CGRect(x: postImageView.right + 10,
                                      y: 5,
                                      width: contentView.width - 20 - size - separatorInset.left,
                                      height: size)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postTitleLabel.text = nil
        postImageView.image = nil
    }
    
    func configureCell(with viewModel: PostPreviewTableViewCellViewModel) {
        postTitleLabel.text = viewModel.title
        if let data = viewModel.imageData {
            postImageView.image = UIImage(data: data)
        } else if let url = viewModel.imageURL {
            // Fetch the image and cache it
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let self = self, let data = data else { return }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self.postImageView.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }
    
}

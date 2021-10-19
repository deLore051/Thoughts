//
//  PostHeaderTableViewCell.swift
//  ThoughtsBlogApp
//
//  Created by Stefan Dojcinovic on 19.10.21..
//

import UIKit

class PostHeaderTableViewCellViewModel {
    let imageURL: URL?
    var imageData: Data?
    
    init(imageURL: URL?) {
        self.imageURL = imageURL
    }
}

class PostHeaderTableViewCell: UITableViewCell {
    
    static let identifier = "PostHeaderTableViewCell"
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        addSubview(postImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        postImageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
    }
    
    func configureCell(with viewModel: PostHeaderTableViewCellViewModel) {
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

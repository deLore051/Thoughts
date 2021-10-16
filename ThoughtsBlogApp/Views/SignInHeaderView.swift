//
//  SignInHeaderView.swift
//  ThoughtsBlogApp
//
//  Created by Stefan Dojcinovic on 16.10.21..
//

import UIKit

class SignInHeaderView: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFill
        //imageView.backgroundColor = .systemBlue
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.text = "Explore millions of articles!"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(imageView)
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size: CGFloat = width / 3
        
        imageView.frame = CGRect(x: (width - size) / 2,
                                 y: 10,
                                 width: size,
                                 height: size)
        
        label.frame = CGRect(x: 20,
                             y: imageView.bottom,
                             width: width - 40,
                             height: height - size - 30)
        
    }
    
}

//
//  PayWallDescriptionView.swift
//  ThoughtsBlogApp
//
//  Created by Stefan Dojcinovic on 14.10.21..
//

import UIKit

class PayWallDescriptionView: UIView {

    private let descriptorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.numberOfLines = 0
        label.text = "Join Thoughts Premium to view unlimited articles!"
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 36, weight: .medium)
        label.numberOfLines = 1
        label.text = "4.99$ / month"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(descriptorLabel)
        addSubview(priceLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        descriptorLabel.frame = CGRect(x: 20, y: height / 4, width: width - 40, height: height / 4)
        priceLabel.frame = CGRect(x: 20, y: descriptorLabel.bottom, width: width - 40, height: height / 4)
    }
}

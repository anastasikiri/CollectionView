//
//  HeaderCollectionReusableView.swift
//  CollectionView_Itea
//
//  Created by Anastasia Bilous on 2022-06-23.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
        
    static let identifier = "HeaderCollectionReusableView"
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "My Gallery"
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .clear
        label.font = UIFont(name: "Rockwell Bold", size: 25)
        return label
    }()
    
    public func configure() {
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
}

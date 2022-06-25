//
//  ChosenPictureViewController.swift
//  CollectionViewCompositional_Itea
//
//  Created by Anastasia Bilous on 2022-06-24.
//

import UIKit

class ChosenPictureViewController: UIViewController {
    
    var img = UIImage()
    
    let fullScreenImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(fullScreenImageView)
        fullScreenImageView.frame = self.view.bounds
        fullScreenImageView.image = img
    }
}

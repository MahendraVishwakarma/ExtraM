//
//  HomePhotoCell.swift
//  Mahendra
//
//  Created by Mahendra Vishwakarma on 24/08/20.
//  Copyright © 2020 Mahendra Vishwakarma. All rights reserved.
//

import UIKit

class HomePhotoCell: UICollectionViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    final func setImage(imgData: Data?) {
        photoImageView.image = nil
        if let data = imgData {
            photoImageView.image = UIImage(data: data)
        }
    }
}

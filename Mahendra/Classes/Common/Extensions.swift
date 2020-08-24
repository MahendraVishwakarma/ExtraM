//
//  Extensions.swift
//  Mahendra
//
//  Created by Mahendra Vishwakarma on 25/08/20.
//  Copyright © 2020 Mahendra Vishwakarma. All rights reserved.
//

import Foundation
import UIKit

extension HomeViewController {
    
}


//MARK: collection dataSource methods
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photos?.photos.photo.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HomePhotoCell.self), for: indexPath) as? HomePhotoCell else { return UICollectionViewCell()}
        
        if cell.backgroundView == nil {
            let indicator = UIActivityIndicatorView(style: .medium)
            cell.backgroundView = indicator
        }
        
        let indicator = cell.backgroundView as! UIActivityIndicatorView
        let photo = viewModel?.photos?.photos.photo[indexPath.row]
        
        
        switch photo?.photoState {
        case .new:
            indicator.startAnimating()
            
        case .downloaded:
            indicator.stopAnimating()
            
        case .failed:
            indicator.stopAnimating()
        case .none:
            indicator.stopAnimating()
        }
        
        cell.setImage(imgData: photo?.imageData)
        
        
        if let photo = viewModel?.photos?.photos.photo[indexPath.row] {
            viewModel?.startOperations(photoRecord: photo, indexPath: indexPath)
        }
        
        return cell
    }
}

//CollectionView Item Size
extension HomeViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layoutFormat = defaultLayout.rawValue
        let size =  UIScreen.main.bounds.width/CGFloat(layoutFormat) - 30/2
        return CGSize(width: size, height: size)
        
    }
}


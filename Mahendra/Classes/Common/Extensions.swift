//
//  Extensions.swift
//  Created by Mahendra Vishwakarma on 25/08/20.
//  Copyright © 2020 Mahendra Vishwakarma. All rights reserved.
//

import Foundation
import UIKit

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
        case .downloaded, .failed , .none:
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
//MARK:- searchBar  delegate
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            viewModel?.isNeedToAdd = false
            viewModel?.fetchData(with: searchText)
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let  height = homeCollectionView.frame.size.height
        let contentYoffset = homeCollectionView.contentOffset.y
        let distanceFromBottom = homeCollectionView.contentSize.height - contentYoffset
        if distanceFromBottom <= height && (viewModel?.photos?.photos.photo.count ?? 0) > 0 {
            
            if((viewModel?.isFetched ?? false)) {
                viewModel?.isFetched = false
                let page_number = viewModel?.photos?.photos != nil ? (viewModel?.photos?.photos.page ?? 0) + 1 : 1
                let url = String(format: URLs.photos, page_number)
                viewModel?.isNeedToAdd = true
                viewModel?.fetchData(url: url)
                
            }
        }
    }
}
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(viewModel?.photos?.photos.photo[indexPath.row].photoState == .downloaded) {
            let imgViewer = ImageViewer(frame: self.view.bounds)
            //imgViewer.center = self.view.convert(self.view.center, from:self.view.superview)
             self.view.window?.addSubview(imgViewer)

            imgViewer.photos = viewModel?.photos?.photos.photo ?? []
            imgViewer.reloaData()
            imgViewer.selectedID = viewModel?.photos?.photos.photo[indexPath.row].id
            imgViewer.setSelectedIndex()
        }
        
        
    }
}


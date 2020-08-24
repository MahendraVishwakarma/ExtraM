//
//  ImageViewer.swift
//  Mahendra
//
//  Created by Mahendra Vishwakarma on 25/08/20.
//  Copyright © 2020 Mahendra Vishwakarma. All rights reserved.
//

import UIKit

class ImageViewer: UIView {
    
    let xibName = "ImageViewer"
    @IBOutlet private var containerView: UIView!
    @IBOutlet private weak var collectinview: UICollectionView!
    var photos = Array<Photo>()
    var selectedID : String!
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialization()
    }
    
    func setSelectedIndex() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            guard let index = self.photos.lastIndex(where: {$0.id == self.selectedID}) else{
                return
            }
            print(index)
            let indecPath = IndexPath(row: index, section: 0)
            self.collectinview.scrollToItem(at: indecPath, at: .centeredHorizontally, animated: false)
        }
        
    }
    @IBAction private func btnCancel(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    private func initialization() {
        Bundle.main.loadNibNamed(xibName, owner: self, options: nil)
        containerView.setFrameInView(self)
        collectinview.register(UINib(nibName: String(describing: HomePhotoCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: HomePhotoCell.self))
        collectinview.dataSource = self
        collectinview.delegate = self
        
    }
    
}

extension ImageViewer: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HomePhotoCell.self), for: indexPath) as? HomePhotoCell else {
            return HomePhotoCell()
        }
        
        cell.setImage(imgData: photos[indexPath.row].imageData)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size =  UIScreen.main.bounds.width - 30/2
        return CGSize(width: size, height: size)
        
    }
}

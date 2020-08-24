//
//  DownloaderManager.swift
//  Mahendra
//
//  Created by Mahendra Vishwakarma on 24/08/20.
//  Copyright © 2020 Mahendra Vishwakarma. All rights reserved.
//

import Foundation
import UIKit

var imageCache = NSCache<NSString, UIImage>()

class DownloadingOperations {
    lazy var downloadsInProgress: [IndexPath: Operation] = [:]
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Downloading_queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}

class ImageDownloadManager: Operation {
    
    let  photoRecord: Photo
    
    init( photoRecord: Photo) {
        self.photoRecord = photoRecord
    }
    
    override func main() {
        
        if isCancelled {
            return
        }
        let url = String(format: URLs.image, photoRecord.farm,photoRecord.server,photoRecord.id,photoRecord.secret)
        
        // check cached image
        
        guard let imgURL = URL(string: url) else { return }
        let key = imgURL.absoluteString as NSString
        
        if let cachedImage = imageCache.object(forKey: key)  {
            photoRecord.imageData = cachedImage.pngData()
            photoRecord.photoState = PhotoRecordState.downloaded
            return
        }
        
        
        guard let imageData = try? Data(contentsOf: imgURL) else { return }
        
        if isCancelled {
            return
        }
        
        
        if !imageData.isEmpty {
            
            DispatchQueue.main.async {
                imageCache.setObject(UIImage(data: imageData)!, forKey: key )
            }
            
            photoRecord.imageData = imageData
            photoRecord.photoState = PhotoRecordState.downloaded
        } else {
            photoRecord.photoState = PhotoRecordState.failed
            photoRecord.imageData = UIImage(named: "placeholder")?.pngData()
        }
    }
}

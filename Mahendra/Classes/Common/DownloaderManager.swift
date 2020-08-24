//
//  DownloaderManager.swift
//  Mahendra
//
//  Created by Mahendra Vishwakarma on 24/08/20.
//  Copyright © 2020 Mahendra Vishwakarma. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, NSData>()

class PendingOperations {
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
        guard let imgURL = URL(string: url) else { return }
        guard let imageData = try? Data(contentsOf: imgURL) else { return }
        
        if isCancelled {
            return
        }
        // check cached image
        if let cachedImage = imageCache.object(forKey: url as NSString)  {
            photoRecord.imageData = cachedImage as Data
            photoRecord.photoState = PhotoRecordState.downloaded
            return
        }
        
        if !imageData.isEmpty {
            imageCache.setObject(imageData as NSData, forKey: url as NSString)
            photoRecord.imageData = imageData
            photoRecord.photoState = PhotoRecordState.downloaded
        } else {
            photoRecord.photoState = PhotoRecordState.failed
            photoRecord.imageData = UIImage(named: "placeholder")?.pngData()
        }
    }
}

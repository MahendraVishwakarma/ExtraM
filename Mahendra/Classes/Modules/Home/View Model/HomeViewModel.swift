//
//  HomeViewModel.swift
//  Mahendra
//
//  Created by Mahendra Vishwakarma on 24/08/20.
//  Copyright © 2020 Mahendra Vishwakarma. All rights reserved.
//

import Foundation


final class HomeViewModel: NSObject {
    
    weak var delegate: FetchDataProtocols?
    let pendingOperations = PendingOperations()
    var photos: PhotoModel?
    
    func fetchData(url: String) {
        
        WebServices.requestHttp(urlString: url, method: .Get, param: nil, decode: { (json) -> PhotoModel? in
            guard let response = json as? PhotoModel else{
                return nil
            }
            
            return response
            
        }) { (result) in
            
            switch result {
            case .success(let list) :
                
                self.photos = list
                self.delegate?.updateView()
                break
            case .failure(let error) :
                print(error.localizedDescription)
               // self.delegate?.generateError(error: error)
                break
            }
        }
    }
    
    func fetchData(with query: String) {
        
    }
    
    func startOperations(photoRecord: Photo, indexPath: IndexPath) {
      
        if( photoRecord.photoState == PhotoRecordState.new) {
            print("checking state:" + photoRecord.photoState!.rawValue)
            startDownload(photoRecord: photoRecord, at: indexPath)
        } else {
             print("checking other status:" + photoRecord.photoState!.rawValue)
        }
    }
    
    func startDownload(photoRecord: Photo, at indexPath: IndexPath) {
    
        guard pendingOperations.downloadsInProgress[indexPath] == nil else {
            return
        }
        
        let downloader = ImageDownloadManager(photoRecord: photoRecord)
        
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            
            DispatchQueue.main.async {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.delegate?.updateView()
                
            }
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
}


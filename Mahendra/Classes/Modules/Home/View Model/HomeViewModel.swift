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
    let pendingOperations = DownloadingOperations()
    var photos: PhotoModel?
    var isFetched: Bool = true
    var isNeedToAdd:Bool = false
    
    func fetchData(url: String) {
        
        WebServices.requestHttp(urlString: url, method: .Get, param: nil, decode: { (json) -> PhotoModel? in
            guard let response = json as? PhotoModel else{
                return nil
            }
            return response
            
        }) { [weak self] (result) in
            self?.isFetched = true
            
            switch result {
            case .success(let list) :
                if((self?.isNeedToAdd ?? false)) {
                    self?.photos?.photos.photo.append(contentsOf: list?.photos.photo ?? [])
                    self?.photos?.photos.page = list?.photos.page ?? 0
                } else {
                    self?.photos = list
                }
                self?.isNeedToAdd = false
                self?.delegate?.updateView()
                break
            case .failure(let error) :
                print(error.localizedDescription)
                
                break
            }
        }
    }
    
    func fetchData(with query: String) {
        let url = String(format: URLs.search, query)
        fetchData(url: url)
    }
    
    func startOperations(photoRecord: Photo, indexPath: IndexPath) {
        
        if( photoRecord.photoState == PhotoRecordState.new) {
            startDownload(photoRecord: photoRecord, at: indexPath)
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


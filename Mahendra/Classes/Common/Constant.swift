//
//  Comman.swift
//  AssignmentMV
//
//  Created by Mahendra Vishwakarma on 13/10/19.
//  Copyright © 2019 Mahendra Vishwakarma. All rights reserved.
//

import Foundation

// constant values
class Constants {
    
    static let api_key = "cfb64f7c256cf5faf024a8d71b6339cd"
    static let secret = "8a497e441e6f0a81"
}
class URLs {
    static let photos = "https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=\(Constants.api_key)&per_page=36&page=%i&format=json&nojsoncallback=1"
    static let image = "https://farm%i.staticflickr.com/%@/%@_%@.jpg"
    static let search = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=cfb64f7c256cf5faf024a8d71b6339cd&text=%@&format=json&nojsoncallback=1"
}

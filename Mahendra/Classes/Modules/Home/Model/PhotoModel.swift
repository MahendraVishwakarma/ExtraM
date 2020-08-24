//
//  PhotoModel.swift
//  Mahendra
//
//  Created by Mahendra Vishwakarma on 24/08/20.
//  Copyright © 2020 Mahendra Vishwakarma. All rights reserved.
//

import Foundation
import UIKit

// MARK: - PhotoModel
class PhotoModel: Codable {
    let photos: Photos
    let stat: String

    init(photos: Photos, stat: String) {
        self.photos = photos
        self.stat = stat
    }
}

// MARK: - Photos
class Photos: Codable {
    let page, pages, perpage: Int
    let total: Total
    let photo: [Photo]

    init(page: Int, pages: Int, perpage: Int, total: Total, photo: [Photo]) {
        self.page = page
        self.pages = pages
        self.perpage = perpage
        self.total = total
        self.photo = photo
    }
}

// MARK: - Photo
class Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
    var imageData : Data?
    lazy var photoState: PhotoRecordState? = .new

    init(id: String, owner: String, secret: String, server: String, farm: Int, title: String, ispublic: Int, isfriend: Int, isfamily: Int) {
        self.id = id
        self.owner = owner
        self.secret = secret
        self.server = server
        self.farm = farm
        self.title = title
        self.ispublic = ispublic
        self.isfriend = isfriend
        self.isfamily = isfamily
        
    }
}


enum Total: Codable {
    case integer(Int)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Total.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for total"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

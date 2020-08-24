//
//  Enums.swift
//  Mahendra
//
//  Created by Mahendra Vishwakarma on 24/08/20.
//  Copyright © 2020 Mahendra Vishwakarma. All rights reserved.
//

import Foundation


enum PhotoRecordState:String {
    case new
    case downloaded
    case failed
}

// generics type
public enum Result<T, U> where U:Error{
    case success(T)
    case failure(U)
}

// custom error
public enum APIError:Error{
    
    case failedRequest(String?)
}

// hTTPS methods type
public enum HttpsMethod{
    case Post
    case Get
    case Put
    case Delate
    
    var localization:String{
        switch self {
        case .Post: return "POST"
        case .Get: return "GET"
        case .Put: return "PUT"
        case .Delate: return "Delete"
            
        }
        
    }
}

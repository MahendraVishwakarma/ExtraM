//
//  Protocols.swift
//  Mahendra
//
//  Created by Mahendra Vishwakarma on 24/08/20.
//  Copyright © 2020 Mahendra Vishwakarma. All rights reserved.
//

import Foundation

//use for fetch data from server
protocol FetchDataProtocols: AnyObject {
    func fetchData()
    func fetchData(with quesry: String)
    func updateView()
}

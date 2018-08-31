//
//  Network.swift
//  PhotoPartyUpload
//
//  Created by iT Gurus Software on 30/08/18.
//  Copyright © 2018 iT Gurus Software. All rights reserved.
//

import Foundation

class Network : NSObject {
    static let sharedInstance = Network()
    
    
    lazy var helperSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration)
    }()
    
    lazy var downloadSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration)
    }()
    
    
    private override init() { }
}

//
//  HelperModel.swift
//  PhotoPartyUpload
//
//  Created by iT Gurus Software on 13/06/18.
//  Copyright © 2018 iT Gurus Software. All rights reserved.
//

import Foundation

class HelperModel : Equatable {
   
    var url : String
    
    var name : String
    
    var uniqueId : String
    
    var currentEventName : String
    
    var osName : String
    
    var parser : XMLParser?
    
    var currentXMLTag : String
        
    static func == (lhs: HelperModel, rhs: HelperModel) -> Bool {
        return lhs.uniqueId == rhs.uniqueId
    }

    init() {
         url = ""
        
         name = ""
        
         uniqueId = ""
        
         currentEventName = ""
        
         osName = ""
        
         parser = nil
        
         currentXMLTag = ""
    }
    
}

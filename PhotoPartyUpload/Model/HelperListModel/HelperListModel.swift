//
//  HelperListModel.swift
//  PhotoPartyUpload
//
//  Created by iT Gurus Software on 13/06/18.
//  Copyright © 2018 iT Gurus Software. All rights reserved.
//

import Foundation

class HelperListModel
{
   
    
    static let sharedList = HelperListModel()
    
    private init() {}
    
    var helperList = [HelperModel]()


    subscript(name: String) -> HelperModel? {
        get {
            // return an appropriate subscript value here
            
            let lowerCaseName = name.lowercased()
            
            for helper in helperList
            {
                if (helper.name.lowercased() == lowerCaseName) || (helper.url.lowercased() == lowerCaseName) || (String(format: "%@/", helper.url) == lowerCaseName)
                {
                    return helper
                }
            }
            return nil
            // debug l
        }
    }

    subscript(parser: XMLParser) -> HelperModel? {
        get {
            // return an appropriate subscript value here
            
            for helper in helperList
            {
               if helper.parser == parser
               {
                return helper
                }
            }
            return nil
        }
    }
    
    func getFirstHelper() -> HelperModel?
    {
        if helperList.count == 0 { return nil}
        
        helperList.sort(by: { $0.name.compare($1.name) == .orderedAscending })
        
        return helperList.first
    }
}

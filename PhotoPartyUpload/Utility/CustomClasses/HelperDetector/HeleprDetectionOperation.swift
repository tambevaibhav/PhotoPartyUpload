//
//  HeleprDetectionOperation.swift
//  PhotoPartyUpload
//
//  Created by iT Gurus Software on 19/06/18.
//  Copyright © 2018 iT Gurus Software. All rights reserved.
//

import UIKit

typealias helperCompletion = ((_ result : Bool ,_ helper : HelperModel?) -> ())?

class HeleprDetectionOperation: Operation
{
    var url : URL?
    var completion : helperCompletion

    
    init(url: URL, callBack : helperCompletion) {
        self.url = url
        self.completion = callBack
    }
 
    override func main()
    {
        
        guard let session = Utils.sharedInstance.getBackgroundSession() else {
            return
        }
        let task = session.dataTask(with: url!) { (data, response, error) in
            

            if let url = response?.url
            {
                // Remove query part
                let urlString = url.absoluteString
                let urlArray =  urlString.components(separatedBy: "?")
                let queryToRemove = String(format: "/%@", Constant.HelperXmlTag.serverPingQuery)
                let locationStr = urlArray[0].replacingOccurrences(of: queryToRemove, with: "")
                
                // Create new Helper
                if let helper = HelperListModel.sharedList[locationStr]
                {
                    if let index = HelperListModel.sharedList.helperList.index(of: helper)
                    {
                        HelperListModel.sharedList.helperList.remove(at: index)
                    }
                }
                
                if let helperData = data
                {
                    let parser = XMLParser(data: helperData)
                    let helper = HelperModel()
                    helper.url = locationStr
                    helper.parser = parser
                    HelperListModel.sharedList.helperList.append(helper)
                    self.completion!(true,helper)

                }
                else
                {
                    NSLog("Failed Helper Detection. Url = %@", url.absoluteString)
                    self.completion!(false,nil)
                }
                
            }
            else
            {
                NSLog("Failed Helper Detection. Description = %@", error.debugDescription)
                self.completion!(false,nil)
            }

        }
        
        task.resume()
    }
}

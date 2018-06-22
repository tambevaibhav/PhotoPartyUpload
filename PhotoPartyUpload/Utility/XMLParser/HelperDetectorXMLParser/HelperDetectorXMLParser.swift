//
//  HelperDetectorXMLParser.swift
//  PhotoPartyUpload
//
//  Created by iT Gurus Software on 13/06/18.
//  Copyright © 2018 iT Gurus Software. All rights reserved.
//

import Foundation

extension HelperDetector : XMLParserDelegate
{
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        element = elementName

      //  print("Start Element" + element)
        
        if let helper = HelperListModel.sharedList[parser]
        {
            helper.currentXMLTag = elementName
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
     //   print("found = " + string)

        if element == Constant.HelperXmlTag.helperATag
        {
           listOfHelper.append(string)
        }
       
        if let helper = HelperListModel.sharedList[parser]
        {
           if let tagType = Constant.HelperXmlTag.HelperXMLTagType(rawValue: element)
           {
            switch(tagType)
            {
            case .helperName :
                helper.name = string
                
            case .currentEvent :
                helper.currentEventName = string
                
            case .helperId :
                helper.uniqueId = string
                
            case .osName :
                 helper.osName = string
                
            case .helperDescriptor :
                print("Helper Descriptor")
            }
        }
    }
    }
    
    
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
   //     print("End Element = " + element)

        if elementName == Constant.HelperXmlTag.startTag
        {
            
            if listOfHelper.count == 0
            {
                print("Helper not detected from api")
               self.startAutoHelperDetection()
            }
            else
            {
                var requestCount = 0
                
                for ipAddress in listOfHelper
                {
                    let ipAddressToPing = String(format: "http://%@%@/%@", ipAddress,Constant.HelperXmlTag.serverPort,Constant.HelperXmlTag.serverPingQuery)
                    // ipAddressToPing=@"http://192.168.0.122:8888/ResolveHelper"
                    print("ip Address :- " + ipAddressToPing)
                    
                    var request = URLRequest(url: URL(string: ipAddressToPing)!)
                    request.timeoutInterval = 20
                    
                    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                        if (error != nil)
                        {
                            let url = response?.url?.absoluteURL
                            let array = url?.absoluteString.components(separatedBy: "?")
                            let queryToRemove = "/" + Constant.HelperXmlTag.serverPingQuery
                           guard let locationStr = array?.first?.replacingOccurrences(of: queryToRemove, with: "") else { return }
                            let helper = HelperListModel.sharedList[locationStr]
                            helper?.url = locationStr
                            
                            if let data1 = data
                            {
                                let parser = XMLParser(data: data1)
                                parser.delegate = self
                                if !HelperListModel.sharedList.helperList.contains(where: { $0.name == helper?.name })
                                {
                                    HelperListModel.sharedList.helperList.append(helper!)
                                }
                                
                            }
                        }
                        else
                        {
                            requestCount += 1;
                            if (self.listOfHelper.count == requestCount)
                            {
                              // Remove seach alert
                              // Start download controller
                            }
                        }
                    }
                    task.resume()
                }
            }
        }
        else if elementName == Constant.HelperXmlTag.HelperXMLTagType.helperDescriptor.rawValue
        {
            setHelper()            
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
    {
        
        let helper = HelperListModel.sharedList[parser]
        
        if let foundHelper = helper
        {
            if let index = HelperListModel.sharedList.helperList.index(of: foundHelper)
            {
                HelperListModel.sharedList.helperList.remove(at: index)
            }
        }
    }
}

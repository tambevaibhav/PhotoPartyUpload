//
//  GetImageListParser.swift
//  PhotoPartyUpload
//
//  Created by iT Gurus Software on 29/06/18.
//  Copyright © 2018 iT Gurus Software. All rights reserved.
//

import Foundation

extension DownloadManager : XMLParserDelegate
{
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        if(elementName == Constant.XMLTag.arrayOfString)
        {
            serverImageList = [String]()
            newImageList = [String]()
        }
        self.elementName = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if(elementName == Constant.XMLTag.string)
        {
            newImageList!.append(string)
           // if let originalName = Utils.sharedInstance.removeFileStamp(fileName: string)
            //{
                serverImageList?.append(string)
            //}
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == Constant.XMLTag.arrayOfString {
            // Remove local images and croma images
            self.elementName = nil
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        serverImageList = nil
    }
    
    func parserDidEndDocument(_ parser: XMLParser)
    {
        if (serverImageList != nil)
        {
            checkImageList()
        }
    }
    
    private func checkImageList()
    {
        var isImagesDeleted = false
        
        if (oldImageList != nil)
        {
            for image in oldImageList!
            {
                if(!newImageList!.contains(image))
                {
                    isImagesDeleted = true
                    // delete file
                }
            }
            if (isImagesDeleted == true)
            {
                // reload UI
            }
        }
        
        oldImageList = newImageList
        downloadThumbnails()
    }
    
}

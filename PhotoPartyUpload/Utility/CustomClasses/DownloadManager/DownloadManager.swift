//
//  DownloadManager.swift
//  PhotoPartyUpload
//
//  Created by iT Gurus Software on 29/06/18.
//  Copyright © 2018 iT Gurus Software. All rights reserved.
//

import Foundation

class DownloadManager : NSObject
{
    static let shared = DownloadManager()
    
     var downloadTimer : Timer?
     var serverImageList : [String]?
     var oldImageList : [String]?
     var newImageList : [String]?
     var elementName : String?
     var downloadImageOperationQueue : OperationQueue?
     var downloadVideoOperationQueue : OperationQueue?

   
       // MARK: - Private Constructor
    private override init()
    {
        
    }
   
       // MARK: - Timer Methods
    func startDownloader()
    {
      DispatchQueue.main.async
    {
        if self.downloadTimer != nil
        {
            self.downloadTimer?.invalidate()
        }
        self.downloadTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.getServerImageList), userInfo: nil, repeats: true)
        self.downloadTimer?.fire()
        }
    }
    
    func stopDownloader()
    {
        if downloadTimer != nil
        {
            downloadTimer?.invalidate()
        }
    }
    
       // MARK: - Get Image List
    @objc private func getServerImageList()
    {
        guard let helperUrl =  UserDefaults.standard.value(forKey: "helperUrl") as? String else { return }
       
        let getListUrl = String(format: Constant.Urls.getListUrl, helperUrl) 
        
        let dataTask = URLSession.shared.dataTask(with: URL(string: getListUrl)!) { (data, respose, error) in
            
            if (error == nil && data != nil)
            {
                let xmlParser = XMLParser(data: data!)
                xmlParser.delegate = self
                xmlParser.parse()
            }
            else
            {
                print("Error in GetList Service :- \(error!.localizedDescription)")
            }
        }
        dataTask.resume()
    }
    
    
    
    func downloadThumbnails()
    {
        downloadImageOperationQueue = OperationQueue()
        downloadImageOperationQueue?.name = "ImageDownload"
        
        for imageName in serverImageList!
        {
            
            
            let operation1 = ImageDownloadOperation(imageName: imageName, resolution: ImageResolution.small) { (result) in
                if result == true
                {
                    print("small operation completed \(imageName)")
                }
                else
                {
                    print("failed small operation completed \(imageName)")

                }
            }
            let operation2 = ImageDownloadOperation(imageName: imageName, resolution: ImageResolution.medium) { (result) in
                if result == true
                {
                    print("medium operation completed \(imageName)")
                }
                else
                {
                    print("failed medium operation completed \(imageName)")
                    
                }
            }
            let operation3 = ImageDownloadOperation(imageName: imageName, resolution: ImageResolution.large) { (result) in
                if result == true
                {
                    print("large operation completed \(imageName)")
                }
                else
                {
                    print("failed large operation completed \(imageName)")
                    
                }
            }
            
            downloadImageOperationQueue?.addOperation(operation1)
            downloadImageOperationQueue?.addOperation(operation2)
            downloadImageOperationQueue?.addOperation(operation3)
        }
    }
    
}

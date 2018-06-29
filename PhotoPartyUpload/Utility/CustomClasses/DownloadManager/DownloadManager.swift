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
     var elementName : String?
   
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
    
    
    
}

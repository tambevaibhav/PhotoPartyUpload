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
            if isDownloaded(name: imageName, folder: Constant.FolderName.smallThumb) == false
            {
            let operation1 = ImageDownloadOperation(imageName: imageName, resolution: ImageResolution.small) { (result) in
                if result == true
                {
                    print("Small thumbnail downloaded :-  \(imageName)")
                    self.updateUI(imageName: imageName)
                }
                else
                {
                    print("Small thumbnail download failed \(imageName)")
                }
                }
                downloadImageOperationQueue?.addOperation(operation1)
            }
            
            if isDownloaded(name: imageName, folder: Constant.FolderName.mediumThumb) == false
            {
            let operation2 = ImageDownloadOperation(imageName: imageName, resolution: ImageResolution.medium) { (result) in
                if result == true
                {
                    print("Medium thumbnail downloaded :-  \(imageName)")
                    self.updateUI(imageName: imageName)
                }
                else
                {
                    print("Medium thumbnail download failed :-  \(imageName)")
                }
            }
                downloadImageOperationQueue?.addOperation(operation2)
            }
           
            if isDownloaded(name: imageName, folder: Constant.FolderName.largeThumb) == false
            {
            let operation3 = ImageDownloadOperation(imageName: imageName, resolution: ImageResolution.large) { (result) in
                if result == true
                {
                    print("Large thumbnail downloaded :-  \(imageName)")
                    self.updateUI(imageName: imageName)
                }
                else
                {
                    print("Large thumbnail download failed :-  \(imageName)")
                }
            }
            downloadImageOperationQueue?.addOperation(operation3)
            }
        }
    }
    
    
    func checkAllThumbDownloaded(name : String) -> Bool
    {
        if isDownloaded(name: name, folder: Constant.FolderName.smallThumb) == true && isDownloaded(name: name, folder: Constant.FolderName.mediumThumb) == true && isDownloaded(name: name, folder: Constant.FolderName.largeThumb) == true {
            return true
        }
        return false
    }
    
    func isDownloaded(name: String, folder: String) -> Bool
    {
        let helperImages = Utils.sharedInstance.getDocumentPath().appendingPathComponent(Constant.FolderName.helperImages)
        let folderName = helperImages.appendingPathComponent(folder)
        let fileName = folderName.appendingPathComponent(name)
        
       return Utils.sharedInstance.isFilePresent(url: fileName)
    }
    
    func updateUI(imageName : String) {
        if checkAllThumbDownloaded(name: imageName) == true {
            
            let imageObj = PartyImageModelList.shared.photoPartyModelList.filter {
                $0.imageName == imageName
            }
            
            if imageObj.count == 0 {
            let partyImageModel = PartyImageModel(imageName: imageName)
           
            RealmManager.sharedInstance.saveImage(imageName: imageName, imageType: partyImageModel.imageType.rawValue)
            PartyImageModelList.shared.photoPartyModelList.append(partyImageModel)
    
            let notificationName = Notification.Name(Constant.NotificationIdentifier.downloadIdentifier)
            NotificationCenter.default.post(name: notificationName, object: nil)
            }
        }
    }
}

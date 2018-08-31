//
//  MainViewModel.swift
//  PhotoPartyUpload
//
//  Created by iT Gurus Software on 11/04/18.
//  Copyright © 2018 iT Gurus Software. All rights reserved.
//

import Foundation
import UIKit

class MainViewModel : MainViewProtocol
{
    var statusDidChange: ((MainViewProtocol) -> ())?

    var showSearchAlert: ((MainViewProtocol) -> ())?
    
    var showChoiceAlert: ((MainViewProtocol) -> ())?
    
    var showNoHelperFoundAlert : ((MainViewProtocol) -> ())?
    
    var reloadData: ((MainViewProtocol) -> ())?
    
    var connectionImageArray = [UIImage]()
    
    var isStartUp = false
    
    
    var connectionStatus: ConnectionStatus
    {
        didSet {
            self.statusDidChange?(self)
        }
    }
    
    required init(connectionStatus : ConnectionStatus)
    {
        self.connectionStatus = connectionStatus
        
        for i in 0...22
        {
            let imageName = String(format: "connection_search00%02d",i)
            let path = Bundle.main.path(forResource: imageName, ofType: "png")
            if let image = UIImage(named: path!)
            {
                connectionImageArray.append(image)
            }
        }
    }
    
    
    func startUpThings()
    {
        isStartUp = true
        if createFolders() != true { return }
        startHelperDetection()
        getImageList()
    }
    
    func getImageList() {
       let imageArray = RealmManager.sharedInstance.getImages()
        
        for image in imageArray {
            let partyObject = PartyImageModel(imageName: image.imageName)
            PartyImageModelList.shared.photoPartyModelList.append(partyObject)
        }
        self.reloadData?(self)
    }
    
    func startHelperDetection()
    {
        UserSettings.sharedInstance.setUpUserSettings()
        
        let settings = UserSettings.sharedInstance.getUserSettings()
        
        if settings?.isAutoSearchMode == true
        {
            NSLog("Auto Search")
            self.connectionStatus = .searching
            self.showSearchAlert?(self)
            HelperDetector.sharedInstance.getHelper { (result) in
                if result == true
                {
                    if self.isStartUp == true
                    {
                        self.isStartUp = false
                        UserDefaults.standard.set(HelperListModel.sharedList.helperList[0].url, forKey: "helperUrl")
                        DownloadManager.shared.startDownloader()
                        self.connectionStatus = .active
                    }
                    self.showChoiceAlert?(self)
                }
                else
                {
                    self.showNoHelperFoundAlert?(self)
                }
            }
        }
        else
        {
            NSLog("Manual Search")
        }
    }
    
    func createFolders() -> Bool
    {
        let helperImages = Utils.sharedInstance.getDocumentPath().appendingPathComponent(Constant.FolderName.helperImages)
        let smallFolderName = helperImages.appendingPathComponent(Constant.FolderName.smallThumb)
        let mediumFolderName = helperImages.appendingPathComponent(Constant.FolderName.mediumThumb)
        let largeFolderName = helperImages.appendingPathComponent(Constant.FolderName.largeThumb)
        
        var isSmallCreated = true
        var isMediumCreated = true
        var isLargeCreated  = true

        if (Utils.sharedInstance.isFilePresent(url: smallFolderName) == false)
        {
            isSmallCreated =  Utils.sharedInstance.createFolder(folderName: smallFolderName)
        }
        if Utils.sharedInstance.isFilePresent(url: mediumFolderName) == false
        {
            isMediumCreated = Utils.sharedInstance.createFolder(folderName: mediumFolderName)
        }
        if Utils.sharedInstance.isFilePresent(url: largeFolderName) == false
        {
            isLargeCreated = Utils.sharedInstance.createFolder(folderName: largeFolderName)
        }
        
        if isSmallCreated == true && isMediumCreated == true && isLargeCreated == true
        {
            return true
        }
        else
        {
            return false
        }
    }
}

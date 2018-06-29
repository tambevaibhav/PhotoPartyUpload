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
    
    var connectionImageArray = [UIImage]()
    
    var isStartUp = false
    
    
    var connectionStatus: ConnectionStatus
    {
        didSet {
            self.statusDidChange?(self)
        }
    }
    
    func startUpThings()
    {
        isStartUp = true
        startHelperDetection()
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
}

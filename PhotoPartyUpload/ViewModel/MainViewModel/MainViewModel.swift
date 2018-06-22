//
//  MainViewModel.swift
//  PhotoPartyUpload
//
//  Created by iT Gurus Software on 11/04/18.
//  Copyright © 2018 iT Gurus Software. All rights reserved.
//

import Foundation

class MainViewModel : MainViewProtocol
{
    var statusDidChange: ((MainViewProtocol) -> ())?

    var showSearchAlert: ((MainViewProtocol) -> ())?
    
    var showChoiceAlert: ((MainViewProtocol) -> ())?
    
    var showNoHelperFoundAlert : ((MainViewProtocol) -> ())?
    
    var connectionStatus: ConnectionStatus {
        didSet {
            self.statusDidChange?(self)
        }
    }
    
    func startUpThings()
    {
        UserSettings.sharedInstance.setUpUserSettings()
        
        let settings = UserSettings.sharedInstance.getUserSettings()
        
        if settings?.isAutoSearchMode == true
        {
            NSLog("Auto Search")
            self.connectionStatus = .searching
            self.showSearchAlert?(self)
            HelperDetector.sharedInstance.getHelper { (result) in
                NSLog("In Helper Detection")
                
                if result == true
                {
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
    }
    
    
    
    func getHelperUrl()
    {
        
    }
}

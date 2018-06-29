//
//  Constants.swift
//  PhotoPartyUpload
//
//  Created by iT Gurus Software on 12/04/18.
//  Copyright © 2018 iT Gurus Software. All rights reserved.
//

import Foundation

struct Constant {
    
    struct SearchAlert {
        static let title = "Photo Party Upload"
        static let message = "Searching for Helper in local network.Please wait..."
        static let buttonTitle = "Stop"
    }
    
    struct NoHelperFoundAlert {
        static let message = "No helper could be detected automatically. Please enter the service location"
        static let buttonTitle = "OK"
    }
    
    
    struct HelperUrl {
        static let kEventHelperUrlLive = "http://login.photopartyupload.com/WCFSevices/AuthenticateServicePack.svc" 
        static let kEventHelperUrlStaging = "http://staging.partyuploads.com/WCFSevices/AuthenticateServicePack.svc"
        static let kEventHelperUrlLocal = "http://192.168.0.160:8056/WCFSevices/AuthenticateServicePack.svc"
    }
    
    struct HelperXmlTag {
        static let startTag = "s:Envelope"
        static let helperATag = "a:string"
        static let serverPort = ":8888"
        static let serverPingQuery = "ResolveHelper"
        
        enum HelperXMLTagType : String {
            case helperName = "Name"
            case helperId = "UniqueId"
            case currentEvent = "CurrentEvent"
            case osName = "OSName"
            case helperDescriptor = "HelperDescriptor"
        }
    }
    
    struct HelperSelectionConstant {
        static let title = "Connection "
        static let message = "We have found a helper"
        static let cancelButtonTitle = "cancel"
        static let firstChoice = "use it"
        static let secondChoice = "open settings"
    }
    
    struct FolderName {
        static let userSetting = "UserSettings"
        static let userSettingPList = "UserSettings.plist"
    }
    
    struct Urls
    {
        static let getListUrl = "%@/List?folder=folder1"
    }
    
    struct XMLTag
    {
        static let arrayOfString = "ArrayOfstring"
        static let string = "string"
    }
}

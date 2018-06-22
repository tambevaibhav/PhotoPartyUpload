//
//  UserSettings.swift
//  PhotoPartyUpload
//
//  Created by iT Gurus Software on 20/06/18.
//  Copyright © 2018 iT Gurus Software. All rights reserved.
//

import Foundation

class UserSettings
{
    
    static let sharedInstance = UserSettings()
    private init() {}
    private var userSettingsModel : UserSettingsModel?
    
    
    func setUpUserSettings()
    {
        let folderName = Utils.sharedInstance.getDocumentPath().appendingPathComponent(Constant.FolderName.userSetting)
        let fileUrl = folderName.appendingPathComponent(Constant.FolderName.userSettingPList)
        
        if (Utils.sharedInstance.isFilePresent(url: folderName) == false)
        {
            if Utils.sharedInstance.createFolder(folderName: folderName)
            {
                let documentsURL = Bundle.main.resourceURL?.appendingPathComponent(Constant.FolderName.userSettingPList)
                do
                {
                    try FileManager.default.copyItem(atPath: (documentsURL?.path)!, toPath: fileUrl.path)
                } catch let error as NSError
                {
                    print("Couldn't copy User Settings to final location! Error:\(error.description)")
                }
            }
        }
        
        
        if let userDict = NSDictionary(contentsOfFile: fileUrl.path) as? [String:Any]
        {
            convertSettingsIntoModel(userDict: userDict)
        }
        
    }
    
    private func convertSettingsIntoModel(userDict : [String:Any])
    {
        let contrast = userDict["Contrast"] as! Int
        let IsText = userDict["IsText"] as! Bool
        let disbleInternetSharing = userDict["DisbleInternetSharing"] as! Bool
        let gray = userDict["Gray"] as! Int
        let isSlideShowOverlay = userDict["IsSlideShowOverlay"] as! Bool
        let maxImageSelectionCount = userDict["MaxImageSelectionCount"] as! Int
        let foundedHelperName = userDict["FoundedHelperName"] as! String
        let isTimeOutForSharing = userDict["IsTimeOutForSharing"] as! Bool
        let marginTop = userDict["MarginTop"] as! Int
        let isAlbumMode = userDict["IsAlbumMode"] as! Bool
        let slideOrientation = userDict["SlideOrientation"] as! Int
        let brightness = userDict["Brightness"] as! Int
        let slideDuration = userDict["SlideDuration"] as! Int
        let softness = userDict["Softness"] as! Int
        let isAutoSearchMode = userDict["IsAutoSearchMode"] as! Bool
        let isRemovePrint = userDict["IsRemovePrint"] as! Bool
        let overridePrinterName = userDict["OverridePrinterName"] as! String
        let keyColor = userDict["KeyColor"] as! String
        let maxPrintCount = userDict["MaxPrintCount"] as! Int
        let isDraw = userDict["IsDraw"] as! Bool
        let slideShowMode = userDict["SlideShowMode"] as! Int
        let hue = userDict["Hue"] as! Int
        let timeOutForSharing = userDict["TimeOutForSharing"] as! Int
        let backgroundRemovalOption = userDict["BackgroundRemovalOption"] as! Int
        let isGifFrameSelection = userDict["IsGifFrameSelection"] as! Bool
        let isProp = userDict["IsProp"] as! Bool
        let showAfter = userDict["ShowAfter"] as! Int
        let threshold = userDict["Threshold"] as! Int
        let saturation = userDict["Saturation"] as! Int
        let isDisablePinchToZoom = userDict["IsDisablePinchToZoom"] as! Bool
        let isPhotoEdit = userDict["IsPhotoEdit"] as! Bool
        let marginRight = userDict["MarginRight"] as! Int
        let transitionDuration = userDict["TransitionDuration"] as! Int
        let deletePhotoPassword = userDict["DeletePhotoPassword"] as! String
        let marginBottom = userDict["MarginBottom"] as! Int
        let isDeletePhoto = userDict["IsDeletePhoto"] as! Bool
        let isSlideShow = userDict["IsSlideShow"] as! Bool
        let marginLeft = userDict["MarginLeft"] as! Int
        let isVideoFrameSelection = userDict["IsVideoFrameSelection"] as! Bool
        
        UserSettings.sharedInstance.userSettingsModel = UserSettingsModel(contrast: contrast, IsText: IsText, disbleInternetSharing: disbleInternetSharing, gray: gray, isSlideShowOverlay: isSlideShowOverlay, maxImageSelectionCount: maxImageSelectionCount, foundedHelperName: foundedHelperName, isTimeOutForSharing: isTimeOutForSharing, marginTop: marginTop, isAlbumMode: isAlbumMode, slideOrientation: slideOrientation, brightness: brightness, slideDuration: slideDuration, softness: softness, isAutoSearchMode: isAutoSearchMode, isRemovePrint: isRemovePrint, overridePrinterName: overridePrinterName, keyColor: keyColor, maxPrintCount: maxPrintCount, isDraw: isDraw, slideShowMode: slideShowMode, hue: hue, timeOutForSharing: timeOutForSharing, backgroundRemovalOption: backgroundRemovalOption, isGifFrameSelection: isGifFrameSelection, isProp: isProp, showAfter: showAfter, threshold: threshold, saturation: saturation, isDisablePinchToZoom: isDisablePinchToZoom, isPhotoEdit: isPhotoEdit, marginRight: marginRight, transitionDuration: transitionDuration, deletePhotoPassword: deletePhotoPassword, marginBottom: marginBottom, isDeletePhoto: isDeletePhoto, isSlideShow: isSlideShow, marginLeft: marginLeft, isVideoFrameSelection: isVideoFrameSelection)
    }
    
    func getUserSettings() -> UserSettingsModel?
    {
        return UserSettings.sharedInstance.userSettingsModel
    }
}

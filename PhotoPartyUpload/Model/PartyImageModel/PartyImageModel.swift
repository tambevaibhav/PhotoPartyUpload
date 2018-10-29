//
//  PartyImageModel.swift
//  PhotoPartyUpload
//
//  Created by iT Gurus Software on 29/06/18.
//  Copyright © 2018 iT Gurus Software. All rights reserved.
//

import Foundation

enum ImageType : Int {
    case bitMap = 0
    case gif
    case panaroma
    case video
}

class PartyImageModel
{
    let imageName : String
    let imageType : ImageType
    var isSelected : Bool
    
    init(imageName : String)
    {
        self.imageName = imageName
        self.isSelected = false
        self.imageType = PartyImageModel.getImageType(imageName: imageName)
    }
    
    private static func getImageType(imageName : String) -> ImageType
    {
        let gifExtension = "gif"
        
        let fileExtension = imageName.components(separatedBy: ".")
        if fileExtension.count > 0 {
        let isVideo = PartyImageModel.isVideoFile(fileExtension: fileExtension.last!)
        
        if isVideo == true
        {
            return ImageType.video
        }
        else if(fileExtension.last == gifExtension)
        {
            return ImageType.gif
        }
        else if(fileExtension.count > 2)
        {
            if let secondExtension = fileExtension[fileExtension.count - 2] as String? {
                let extensionWithoutHash = secondExtension.components(separatedBy: "#")
                if let panaromaExtension = extensionWithoutHash.first {
                    if panaromaExtension == "3603d" || panaromaExtension == "360" {
                        return ImageType.panaroma
                        }
                    }
                }
            }
        }
        return ImageType.bitMap
    }
    
    static func isVideoFile(fileExtension : String) -> Bool
    {
        let videoExtentions = ["MOV", "AVI", "MP4", "3GP", "FLV", "M4V", "MKV", "MPEG", "MPG"]

        if videoExtentions.contains(where: {$0.caseInsensitiveCompare(fileExtension) == .orderedSame}) {
            print(true)  // true
            return true
        }
        
        return false
    }
    
     func setIsSelected(isSelected : Bool)
    {
        self.isSelected = isSelected
    }
    
}

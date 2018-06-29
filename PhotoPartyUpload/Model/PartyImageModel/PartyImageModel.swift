//
//  PartyImageModel.swift
//  PhotoPartyUpload
//
//  Created by iT Gurus Software on 29/06/18.
//  Copyright © 2018 iT Gurus Software. All rights reserved.
//

import Foundation

enum ImageType {
    case bitMap
    case gif
    case panaroma
    case video
}

struct PartyImageModel
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
        
        let fileExtension = (imageName as NSString).lastPathComponent.lowercased()
        
        let isVideo = PartyImageModel.isVideoFile(fileName: imageName)
        
        if isVideo == true
        {
            return ImageType.video
        }
        else if(fileExtension == gifExtension)
        {
            return ImageType.gif
        }
        else
        {
            let fileNameWithoutExtension = (imageName as NSString).deletingPathExtension
            
            let index2 = fileNameWithoutExtension.range(of: ".", options: .backwards)?.lowerBound
            
            if let substring3 = index2.map(fileNameWithoutExtension.substring(to:))
            {
                return ImageType.panaroma
            }
        }
        
        return ImageType.bitMap
    }
    
    static func isVideoFile(fileName : String) -> Bool
    {
        let videoExtentions = ["MOV", "AVI", "MP4", "3GP", "FLV", "M4V", "MKV", "MPEG", "MPG"]
        let fileExtension = (fileName as NSString).lastPathComponent.lowercased()

        if videoExtentions.contains(where: {$0.caseInsensitiveCompare(fileExtension) == .orderedSame}) {
            print(true)  // true
            return true
        }
        
        return false
    }
    
    mutating func setIsSelected(isSelected : Bool)
    {
        self.isSelected = isSelected
    }
    
}

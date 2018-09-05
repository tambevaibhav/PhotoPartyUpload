//
//  LibraryCollectionViewCell.swift
//  PhotoPartyUpload
//
//  Created by iT Gurus Software on 30/08/18.
//  Copyright © 2018 iT Gurus Software. All rights reserved.
//
import Foundation
import UIKit
import FLAnimatedImage

class LibraryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var selectedImageView: FLAnimatedImageView!
    
    func updateCell(imageDto : PartyImageModel, viewMode : ViewMode) {
    
        var imageData : Data?
        switch  viewMode {
        case .library:
           imageData = Utils.sharedInstance.getThumbnail(imageName: imageDto.imageName, resolution: .small)

        case .slide:
           imageData = Utils.sharedInstance.getThumbnail(imageName: imageDto.imageName, resolution: .large)
        }
        
        if let imageData = imageData {
        if imageDto.imageType == .gif {
            selectedImageView.animatedImage = FLAnimatedImage(animatedGIFData: imageData)
        }
        else {
            selectedImageView.image = UIImage(data: imageData)
        }
        }
    }
}

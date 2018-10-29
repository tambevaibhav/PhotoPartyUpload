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
    @IBOutlet weak var playButton: UIButton!
    
    func updateCell(imageDto : PartyImageModel, viewMode : ViewMode) {
    
        var imageData : Data?
        switch  viewMode {
        case .library:
           imageData = Utils.sharedInstance.getThumbnail(imageName: imageDto.imageName, resolution: .small)
           if let imageData = imageData {
            if imageDto.imageType == .gif || imageDto.imageType == .video {
                playButton.isHidden = false
            }
            else {
                playButton.isHidden = true
            }
            selectedImageView.image = UIImage(data: imageData)
           }
           else {
            print("image data not found \(imageDto.imageName)")
            }

        case .slide:
           imageData = Utils.sharedInstance.getThumbnail(imageName: imageDto.imageName, resolution: .large)
           if let imageData = imageData {
            if imageDto.imageType == .gif {
                playButton.isHidden = true
                selectedImageView.animatedImage = FLAnimatedImage(animatedGIFData: imageData)
            }
            else {
                playButton.isHidden = true
                selectedImageView.image = UIImage(data: imageData)
                if imageDto.imageType == .video {
                    playButton.isHidden = false
                }
            }
           }
           else {
            print("image data not found \(imageDto.imageName)")
            }

        }
        

    }
}

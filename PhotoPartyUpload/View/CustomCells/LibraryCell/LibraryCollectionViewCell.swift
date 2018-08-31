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
    
    func updateCell(imageDto : PartyImageModel) {
    
        guard let imageData = Utils.sharedInstance.getThumbnail(imageName: imageDto.imageName, resolution: .small) else { return }

        if imageDto.imageType == .gif {
            selectedImageView.animatedImage = FLAnimatedImage(animatedGIFData: imageData)
        }
        else {
            selectedImageView.image = UIImage(data: imageData)
        }
    }
}

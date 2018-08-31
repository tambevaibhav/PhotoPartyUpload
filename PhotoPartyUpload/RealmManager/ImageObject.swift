//
//  ImageObject.swift
//  PhotoPartyUpload
//
//  Created by iT Gurus Software on 31/08/18.
//  Copyright © 2018 iT Gurus Software. All rights reserved.
//

import Foundation
import RealmSwift

class ImageObject: Object {
    @objc dynamic var imageName = ""
    @objc dynamic var imageType = 0
    
    override static func primaryKey() -> String? {
        return "imageName"
    }
}

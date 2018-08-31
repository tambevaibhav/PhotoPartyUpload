//
//  RealmManager.swift
//  PhotoPartyUpload
//
//  Created by iT Gurus Software on 31/08/18.
//  Copyright © 2018 iT Gurus Software. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static let sharedInstance = RealmManager()
    
    private init() {
    }
    
    func saveImage(imageName : String, imageType : Int) {
      
             do{
                let realm = try Realm()
            let imageObject = ImageObject()
            imageObject.imageName = imageName
            imageObject.imageType = imageType
                
                try! realm.write {
                    realm.add(imageObject)
                }
             }catch{
                print(error)
            }
    }
    
    
    func getImages() ->   [ImageObject] {
        let realm = try? Realm()
        let results =   realm?.objects(ImageObject.self)
        let result = Array(results!)
        return result
    }
}

//
//  ImageDownloadOperation.swift
//  PhotoPartyUpload
//
//  Created by iT Gurus Software on 29/06/18.
//  Copyright © 2018 iT Gurus Software. All rights reserved.
//

import Foundation

enum ImageResolution : Int
{
    case small = 0
    case medium
    case large
}


class ImageDownloadOperation : Operation
{
    var imageName : String?
    var resolution : ImageResolution?
    var completion : requestCompletionBlock?
    
    init(imageName : String , resolution : ImageResolution ,  callBack : @escaping requestCompletionBlock )
    {
        self.imageName = imageName
        self.resolution = resolution
        self.completion = callBack
    }
    
    override func main()
    {
        guard let helperUrl = UserDefaults.standard.value(forKey: "helperUrl") as? String else { return }
        guard let escapedString = imageName?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
            let downloadUrl = String(format: Constant.Urls.downloadImage, helperUrl,"",escapedString,resolution!.rawValue)
        
        let task  = Network.sharedInstance.downloadSession.downloadTask(with: URL(string: downloadUrl)!) { (locatioUrl, response, error) in
            if let imageUrl = locatioUrl {
                self.saveImage(imageUrl: imageUrl)
                self.completion!(true)
            }
            else {
                self.completion!(false)
            }
        }
        task.resume()
        
        
    }
    
    
    func saveImage(imageUrl : URL)
    {
        let helperImages = Utils.sharedInstance.getDocumentPath().appendingPathComponent(Constant.FolderName.helperImages)
        let folderName = helperImages.appendingPathComponent(Utils.sharedInstance.getFolderName(resolution: self.resolution!))
        let fileUrl = folderName.appendingPathComponent(self.imageName!)
        do
        {
            let imageData = try Data(contentsOf: imageUrl)
            try imageData.write(to: fileUrl)
            
        }catch let error
        {
            print(error.localizedDescription)
            self.completion!(false)
        }
    }
    
}

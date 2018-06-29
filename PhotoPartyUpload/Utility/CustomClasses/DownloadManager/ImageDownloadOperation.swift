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
        
        let task = URLSession.shared.downloadTask(with: URL(string: downloadUrl)!) { (locationUrl, response, error) in
            if error == nil
            {
                self.completion!(true)
            }
            else
            {
                self.completion!(false)
            }
        }
        task.resume()
    }
}

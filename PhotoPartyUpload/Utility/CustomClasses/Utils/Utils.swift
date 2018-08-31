//
//  Utils.swift
//  PhotoPartyUpload
//
//  Created by iT Gurus Software on 12/04/18.
//  Copyright © 2018 iT Gurus Software. All rights reserved.
//

import Foundation
import UIKit

typealias alertCompletionBlock = (Int) -> Void

class Utils
{
    static let sharedInstance = Utils()
    var alert : UIAlertController?
   
    private init(){ }
    
    func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
    
    func showSearchAlert(topController : UIViewController?, title: String?,messsage : String?, cancelButtonTitle : String)
    {
        
        func showAlertController()
        {
            alert = UIAlertController(title: title, message: messsage, preferredStyle: .alert)
            alert?.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: {_ in
                NSLog("Cancel Search")
            }))
            topController?.present(alert!, animated: true, completion: nil)
        }
        
        
        if alert != nil
        {
            self.alert?.dismiss(animated: true, completion: {
                print("Alert removed")
              showAlertController()
            })
        }
        else
        {
            showAlertController()
        }
    }
    
    
    
    
    func removeAlert() {
        self.alert?.dismiss(animated: true, completion: {
            print("Alert removed")
        })
    }
    
    
    func showAdminChoice(helperName : String, topController : UIViewController?, callBack :@escaping alertCompletionBlock)
    {
        
        func showAlertViewController()
        {
            let title = Constant.HelperSelectionConstant.title + helperName
            alert = UIAlertController(title: title, message: Constant.HelperSelectionConstant.message, preferredStyle: .alert)
            
            alert?.addAction(UIAlertAction(title: Constant.HelperSelectionConstant.firstChoice, style: .default, handler:
                {_ in
                    NSLog("Use it")
                    callBack(1)
            }))
            
            alert?.addAction(UIAlertAction(title: Constant.HelperSelectionConstant.secondChoice, style: .default, handler: {_ in
                NSLog("Second Choice")
                callBack(2)
            }))
            
            alert?.addAction(UIAlertAction(title: Constant.HelperSelectionConstant.cancelButtonTitle, style: .cancel, handler: {_ in
                NSLog("Cancel Choice")
                callBack(3)
            }))
            
            topController?.present(alert!, animated: true, completion: nil)
        }
        
        
        
        if alert != nil {
            self.alert?.dismiss(animated: true, completion: {
                print("Alert removed")
                showAlertViewController()
            })
        }
        else
        {
            showAlertViewController()
        }
    }
    
     func getDocumentPath() -> URL {
        let url =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return URL(fileURLWithPath: url)
    }
     func isFilePresent(url: URL) -> Bool{
        return FileManager.default.fileExists(atPath: url.path)
    }
    
     func createFolder(folderName : URL) -> Bool
    {
            do {
                try FileManager.default.createDirectory(atPath: folderName.path, withIntermediateDirectories: true, attributes: nil)
                return true
            } catch let error as NSError {
                NSLog("Unable to create directory \(error.debugDescription)")
                return false
            }
    }
    
    
    func removeFileStamp( fileName : String) -> String?
    {
        let fileNameWithoutExtension = (fileName as NSString).deletingPathExtension
        
        let index2 = fileNameWithoutExtension.range(of: "#", options: .backwards)?.lowerBound
        
        let name = String(fileNameWithoutExtension[..<index2!])
        
        return name
    }
    
    
    func getThumbnail(imageName : String , resolution : ImageResolution) -> Data? {
        let helperImages = self.getDocumentPath().appendingPathComponent(Constant.FolderName.helperImages)
        let folderName = helperImages.appendingPathComponent(self.getFolderName(resolution: resolution))
        let fileUrl = folderName.appendingPathComponent(imageName)
        
        do {
            let imageData = try Data(contentsOf: fileUrl)
            return imageData
        }
        catch let error {
            print(error.localizedDescription)
            return nil
        }
    }

    func getFolderName( resolution : ImageResolution) -> String
    {
        switch resolution
        {
        case .small:
            return Constant.FolderName.smallThumb
        case .medium:
            return Constant.FolderName.mediumThumb
        case .large:
            return Constant.FolderName.largeThumb
        }
    }
}

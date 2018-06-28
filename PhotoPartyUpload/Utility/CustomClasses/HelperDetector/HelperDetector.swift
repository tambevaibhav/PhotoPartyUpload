//
//  HelperDetector.swift
//  PhotoPartyUpload
//
//  Created by iT Gurus Software on 12/04/18.
//  Copyright © 2018 iT Gurus Software. All rights reserved.
//

import Foundation

typealias requestCompletionBlock = (Bool) -> Void

class HelperDetector : NSObject
{
    static let sharedInstance = HelperDetector()
    
    var listOfHelper = [String]()
    
    var element = ""
    
    var helperQueue = OperationQueue()
    
    var callBack : requestCompletionBlock?
    
    var failedRequest : Int = 0
    
    var isHelperFound = false
    
    private override init(){}
    
    func getHelper(callBack :@escaping requestCompletionBlock)
    {
        self.callBack = callBack
        
        if let helperUrl = UserDefaults.standard.value(forKey: "helperUrl") as? String
        {
            let pingQuery = String(format: "%@/%@", helperUrl,Constant.HelperXmlTag.serverPingQuery)
            
            let operation = HeleprDetectionOperation(url: URL(string: pingQuery)!)
            { (result , helper) in
                
                if result == true
                {
                    let parser = helper?.parser
                    parser?.delegate = self
                    parser?.parse()
                }
                else
                {
                        self.getHelpersByAPI()
                }
                
            }
            helperQueue.addOperation(operation)
        }
        else
        {
            getHelpersByAPI()
        }
        
        
    }
    
    private func getHelpersByAPI()
    {
        guard let addr = getWiFiAddress() else { self.callBack!(false); return }
        
        let soapMessage = "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"><SOAP-ENV:Body><GetLocalIPByExternalIP xmlns=\"http://tempuri.org/\"><externalIPAddress>\(addr)</externalIPAddress></GetLocalIPByExternalIP></SOAP-ENV:Body></SOAP-ENV:Envelope>"
        
        let helperUrl = URL(string: Constant.HelperUrl.kEventHelperUrlStaging)
        var request = URLRequest(url: helperUrl!)
        let msgLength = "\(soapMessage.count)"
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("http://tempuri.org/IAuthenticateServicePack/GetLocalIPByExternalIP", forHTTPHeaderField: "Soapaction")
        request.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        request.httpBody = soapMessage.data(using: .utf8, allowLossyConversion: false)
        request.httpMethod = "POST"
        request.timeoutInterval = 30
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error
            {
                print(error.localizedDescription)
                self.startAutoHelperDetection()
            }
            else
            {
                guard let xmlData = data else { return }
                let xmlParser = XMLParser(data: xmlData)
                xmlParser.delegate = self
                xmlParser.parse()
            }
        }
        task.resume()
    }
    
    
    
    private func getWiFiAddress() -> String? {
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
    
    
    func startAutoHelperDetection()
    {
        let ipAddress = getWiFiAddress()
        
        HelperListModel.sharedList.helperList.removeAll()
        
        if ipAddress == "error" || ipAddress == nil
        {
            print("Failed to get ip address")
            self.callBack!(false)
        }
        else
        {
           print("Helper Detection for current ip " + ipAddress!)
            
            helperQueue.maxConcurrentOperationCount = 255
            
           let ipArray = ipAddress?.components(separatedBy: ".")
            
            self.failedRequest = 0
            
            for i in 0...255
            {
                if let firstPart = ipArray?[0],let secondPart = ipArray?[1] ,let thirdPart = ipArray?[2]
                {
                    let pingQuery = String(format: "http://%@.%@.%@.%d%@/%@", firstPart,secondPart,thirdPart,i,Constant.HelperXmlTag.serverPort,Constant.HelperXmlTag.serverPingQuery)
                    
                    let operation = HeleprDetectionOperation(url: URL(string: pingQuery)!)
                    { (result , helper) in
                        
                        if result == true
                        {
                            let parser = helper?.parser
                            parser?.delegate = self
                            parser?.parse()
                        }
                        else
                        {
                            self.failedRequest += 1
                            if self.helperQueue.operations.count == 0 && self.failedRequest == 255 && self.isHelperFound == false
                            {
                                self.callBack!(false)
                            }
                        }
                        
                    }
                    helperQueue.addOperation(operation)
                }
            }
        }
    }
    
    func setHelper()
    {
        helperQueue.cancelAllOperations()
        Utils.sharedInstance.getBackgroundSession()?.invalidateAndCancel()
    
        if (HelperListModel.sharedList.helperList.count > 0)
        {
            let helperUrl = HelperListModel.sharedList.helperList[0].url
            
            if helperUrl != ""
            {
                // update admin settings
                isHelperFound = true
                self.callBack!(true)
            }
        }
    }
    
}

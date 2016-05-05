//
//  Mozscape.swift
//  iMoz
//
//  Created by George Andrews on 5/15/15.
//  Copyright (c) 2015 George Andrews. All rights reserved.
//

import Foundation
import UIKit

let LinksURL = "https://lsapi.seomoz.com/linkscape/url-metrics/"

class Mozscape {
    
    var accessID: String
    var secretKey: String
    var searchURL: String
    var json: NSData?
    
    init(searchURL: String, accessID: String, secretKey: String) {
        self.searchURL = searchURL
        self.accessID = accessID
        self.secretKey = secretKey
    }
    
    func getMozDataFromAPIRequest(success: ((mozJSON: NSData!) -> Void)) {
        
        let expiresInterval = (floor(NSDate().timeIntervalSince1970 + 300) as NSNumber).stringValue
        
        var mozDataURL = LinksURL + searchURL.urlencode()
        mozDataURL += "?Cols=103146471460&Limit=1"
        mozDataURL += "&AccessID=" + accessID
        mozDataURL += "&Expires=" + expiresInterval
        
        let urlSafeSignature = buildURLSafeSignature(expiresInterval)
        
        mozDataURL += "&Signature=" + urlSafeSignature
        
        loadDataFromURL(NSURL(string: mozDataURL)!, completion:{(data, error) -> Void in
            if let urlData = data {
                success(mozJSON: urlData)
            }
            if let dataError = error {
                print(dataError)
            }
        })
    }
    
    private func buildURLSafeSignature(expiresInterval: String) -> String {
        
        let stringToSign = (accessID + "\n" + expiresInterval)
        let sha1Digest = stringToSign.hmacsha1(secretKey)
        let base64Encoded = sha1Digest.base64EncodedDataWithOptions([])
        
        return (NSString(data: base64Encoded, encoding: NSUTF8StringEncoding) as! String).urlencode()
    }
    
    private func loadDataFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
        
        let session = NSURLSession.sharedSession()
        
        let loadDataTask = session.dataTaskWithURL(url, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    let statusError = NSError(domain:"com.iteachcoding", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    completion(data: nil, error: statusError)
                } else {
                    completion(data: data, error: nil)
                }
            }
        })
        
        loadDataTask.resume()
    }
    
}

extension String {
    
    func urlencode() -> String {
        let urlEncoded = self.stringByReplacingOccurrencesOfString(" ", withString: "+")
        return urlEncoded.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
    }
    
    func hmacsha1(key: String) -> NSData {
        
        let dataToDigest = self.dataUsingEncoding(NSUTF8StringEncoding)
        let secretKey = key.dataUsingEncoding(NSUTF8StringEncoding)
        
        let digestLength = Int(CC_SHA1_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLength)
        
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), secretKey!.bytes, secretKey!.length, dataToDigest!.bytes, dataToDigest!.length, result)
        
        return NSData(bytes: result, length: digestLength)
        
    }
    
}

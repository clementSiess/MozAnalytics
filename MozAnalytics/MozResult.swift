//
//  MozResult.swift
//  MozAnalytics
//
//  Created by Siess, Clement on 9/15/15.
//  Copyright (c) 2015 Siess, Clement. All rights reserved.
//

import Foundation
import CoreData

@objc(MozResult)

class MozResult: NSManagedObject {

    @NSManaged var canonicalURL: String
    @NSManaged var mozRank: NSNumber
    @NSManaged var mozSpam: NSNumber
    @NSManaged var mozTrust: NSNumber
    @NSManaged var pageAuthority: NSNumber
    @NSManaged var domainAuthority: NSNumber
    @NSManaged var externalLinks: NSNumber
    
    override func valueForKey(key: String) -> AnyObject? {
        switch key {
        case ResponseField.uu.rawValue:
            return canonicalURL
        case ResponseField.umrp.rawValue:
            return mozRank
        case ResponseField.pda.rawValue:
            return domainAuthority
        case ResponseField.ueid.rawValue:
            return externalLinks
        case ResponseField.upa.rawValue:
            return pageAuthority
            
        default:
            return nil
        }
    }

}


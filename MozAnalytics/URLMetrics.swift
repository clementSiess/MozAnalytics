//
//  URLMetrics.swift
//  MozAnalytics
//
//  Created by Siess, Clement on 9/17/15.
//  Copyright (c) 2015 Siess, Clement. All rights reserved.
//

import Foundation

enum ResponseField: String {
    case uu = "uu", umrp = "umrp", utrp = "utrp", fspsc = "fspsc", upa = "upa", pda = "pda", ueid = "ueid"
    
    static let allVallues = [uu, umrp, upa, pda, ueid]
    static let stringValues = [uu.rawValue, umrp.rawValue, upa.rawValue, pda.rawValue, ueid.rawValue]
}

class URLMetrics {
    static let responseFields: [String: String] = [
    
        "ut": "Title",
        "uu": "Canonical URL",
        "ueid": "External Equity Links",
        "umrp": "MozRank: URL",
        "utrp": "MozTrust",
        "fspsc": "Subdomain Spam Score",
        "upa": "Page Authority",
        "pda": "Domain Authority"
    ]
}
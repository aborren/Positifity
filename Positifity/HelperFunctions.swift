//
//  HelperFunctions.swift
//  Positifity
//
//  Created by Dan Isacson on 26/11/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import Foundation

class HelperFunctions {
    
    class func numberString(input: String) -> Double? {
        let formatter = NSNumberFormatter()
        let parsed = formatter.numberFromString(input)
        return formatter.numberFromString(input) as Double?
    }
 
    class func isAboveIOSVersion(version: String)->Bool{
        let deviceVersion = UIDevice.currentDevice().systemVersion
        if(deviceVersion.compare(version, options: NSStringCompareOptions.NumericSearch, range: nil, locale: nil) != NSComparisonResult.OrderedAscending){
            return true
        }
        return false
    }
}
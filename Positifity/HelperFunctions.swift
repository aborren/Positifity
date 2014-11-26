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
        //var result: Double? = nil
        let parsed = formatter.numberFromString(input)
       /* if let parsed = parsed {
            result = parsed as Double
        }*/
        return formatter.numberFromString(input) as Double?
    }
    
}
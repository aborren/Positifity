//
//  CalendarUtility.swift
//  Positifity
//
//  Created by Dan Isacson on 18/10/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import Foundation

class CalendarUtility {
 
    class func dateFromComponents(month: Int, year: Int) -> NSDate? {
        var comps: NSDateComponents = NSDateComponents()
        comps.month = month
        comps.year = year
        return NSCalendar.currentCalendar().dateFromComponents(comps)
    }
    
    class func dateFromComponents(day: Int, month: Int, year: Int) -> NSDate? {
        var comps: NSDateComponents = NSDateComponents()
        comps.day = day
        comps.month = month
        comps.year = year
        return NSCalendar.currentCalendar().dateFromComponents(comps)
    }
    
}
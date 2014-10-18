//
//  Positifity.swift
//  Positifity
//
//  Created by Dan Isacson on 18/10/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import Foundation
import CoreData

class MarkedDate: NSManagedObject {

    @NSManaged var markedAs: String
    @NSManaged var date: NSDate

    class func createInManagedObjectContext(moc: NSManagedObjectContext, date: NSDate, markedAs: String) -> MarkedDate {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("MarkedDate", inManagedObjectContext: moc) as MarkedDate
        newItem.date = date
        newItem.markedAs = markedAs
        
        return newItem
    }
}

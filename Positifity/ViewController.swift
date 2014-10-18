//
//  ViewController.swift
//  Positifity
//
//  Created by Dan Isacson on 18/10/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }
        else {
            return nil
        }
    }()
    
    var MarkedDates: [MarkedDate] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var comps: NSDateComponents = NSDateComponents()
        comps.day = 10
        comps.month = 1
        comps.year = 2014
        var date: NSDate = NSCalendar.currentCalendar().dateFromComponents(comps)!
        
        let newItem1 = MarkedDate.createInManagedObjectContext(self.managedObjectContext!, date: NSDate(), markedAs: "green")
        let newItem2 = MarkedDate.createInManagedObjectContext(self.managedObjectContext!, date: date, markedAs: "red")
        presentItemInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func presentItemInfo() {
        let fetchRequest = NSFetchRequest(entityName: "MarkedDate")
        
        var comps: NSDateComponents
        var date: NSDate

        comps = NSDateComponents()
        comps.day = 8
        comps.month = 1
        comps.year = 2014
        var fromDate = NSCalendar.currentCalendar().dateFromComponents(comps)!
        
        comps = NSDateComponents()
        comps.day = 9
        comps.month = 11
        comps.year = 2014
        var toDate = NSCalendar.currentCalendar().dateFromComponents(comps)!
        
        let predicate = NSPredicate(format: "date >= %@ && date <= %@", fromDate, toDate)
        
        fetchRequest.predicate = predicate
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [MarkedDate] {
            
            MarkedDates = fetchResults
            
            for m in MarkedDates {
                let day = NSCalendar.currentCalendar().component(NSCalendarUnit.DayCalendarUnit, fromDate: m.date)
                println(day)
                println(m.date.description + " " + m.markedAs)
            }
        }
    }
}


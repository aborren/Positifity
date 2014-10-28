//
//  ViewController.swift
//  Positifity
//
//  Created by Dan Isacson on 18/10/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit
import CoreData

class CalendarViewController: UIViewController, VRGCalendarViewDelegate {

    //Core data
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }
        else {
            return nil
        }
    }()
    
    //Variables
    
    var markedDays: [Int] = []
    var markedColors: [UIColor] = []
    let calendar = VRGCalendarView()
    
    //Button outlets
    
    @IBOutlet var calView: VRGCalendarView!
    @IBOutlet var greenBtn: UIButton!
    @IBOutlet var yellowBtn: UIButton!
    @IBOutlet var redBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //calendar
        self.calendar.delegate = self
        //self.view.addSubview(self.calendar)
        self.calView.addSubview(calendar)
        //calendarLayout()
        
        markCalendarWithCoreData()
        calendar.reloadInputViews()
        println(calendar.frame.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calendarLayout(){
        let xCenterConstraint = NSLayoutConstraint(item: self.calendar, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: .CenterX, multiplier: 1.0, constant: 0)
        
    }

    //Core data access + fill arrays for marking
    func fetchMarkedDaysForCurrentYearMonth(year: Int, month: Int) {
        let fetchRequest = NSFetchRequest(entityName: "MarkedDate")
        let fromDate = CalendarUtility.dateFromComponents(month, year: year)!
        let toDate = CalendarUtility.dateFromComponents(month+1, year: year)!
        let predicate = NSPredicate(format: "date >= %@ && date < %@", fromDate, toDate)
        fetchRequest.predicate = predicate
        
        //clear the arrays
        markedDays = []
        markedColors = []

        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [MarkedDate] {
            for m in fetchResults {
                let day = NSCalendar.currentCalendar().component(NSCalendarUnit.DayCalendarUnit, fromDate: m.date)
                var color = UIColor()
                if(m.markedAs == "green"){
                    color = UIColor.greenColor()
                }else if(m.markedAs == "yellow"){
                    color = UIColor.yellowColor()
                }else{
                    color = UIColor.redColor()
                }
                markedDays.append(day)
                markedColors.append(color)
            }
        }
    }
    
    func deleteEntriesAtDay(day: Int){
        let year = NSCalendar.currentCalendar().component(NSCalendarUnit.YearCalendarUnit, fromDate: calendar.currentMonth)
        let month = NSCalendar.currentCalendar().component(NSCalendarUnit.MonthCalendarUnit, fromDate: calendar.currentMonth)
        
        let fetchRequest = NSFetchRequest(entityName: "MarkedDate")
        let fromDate = CalendarUtility.dateFromComponents(day, month: month, year: year)!
        let toDate = CalendarUtility.dateFromComponents(day+1, month: month, year: year)!
        let predicate = NSPredicate(format: "date >= %@ && date < %@", fromDate, toDate)
        fetchRequest.predicate = predicate
        
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [MarkedDate] {
            for m in fetchResults {
                self.managedObjectContext?.deleteObject(m)
            }
        }
    }
    
    //Calendar delegate functions
    func calendarView(calendarView: VRGCalendarView!, dateSelected date: NSDate!) {
        /*if(greenBtn.selected){
            if(dayIsMarked(NSCalendar.currentCalendar().component(NSCalendarUnit.DayCalendarUnit, fromDate: date))){
                deleteEntriesAtDay(NSCalendar.currentCalendar().component(NSCalendarUnit.DayCalendarUnit, fromDate: date))
            }
            let newItem = MarkedDate.createInManagedObjectContext(self.managedObjectContext!, date: date, markedAs: "green")
        }else if(yellowBtn.selected){
            if(dayIsMarked(NSCalendar.currentCalendar().component(NSCalendarUnit.DayCalendarUnit, fromDate: date))){
                deleteEntriesAtDay(NSCalendar.currentCalendar().component(NSCalendarUnit.DayCalendarUnit, fromDate: date))
            }
            let newItem = MarkedDate.createInManagedObjectContext(self.managedObjectContext!, date: date, markedAs: "yellow")
        }else if(redBtn.selected){
            if(dayIsMarked(NSCalendar.currentCalendar().component(NSCalendarUnit.DayCalendarUnit, fromDate: date))){
                deleteEntriesAtDay(NSCalendar.currentCalendar().component(NSCalendarUnit.DayCalendarUnit, fromDate: date))
            }
            let newItem = MarkedDate.createInManagedObjectContext(self.managedObjectContext!, date: date, markedAs: "red")
        }else{
        }*/
        
        greenBtn.selected = false
        yellowBtn.selected = false
        redBtn.selected = false
        
        let day = NSCalendar.currentCalendar().component(NSCalendarUnit.DayCalendarUnit, fromDate: date)
        
        if(dayIsMarked(day)){
            selectButtonFromMarkedDate(day)
        }
        markCalendarWithCoreData()
        calendar.reloadInputViews()
    }
    
    func calendarView(calendarView: VRGCalendarView!, switchedToMonth month: Int32, targetHeight: Float, animated: Bool) {
        markCalendarWithCoreData()
    }
    
    func markCalendarWithCoreData(){
        let year = NSCalendar.currentCalendar().component(NSCalendarUnit.YearCalendarUnit, fromDate: calendar.currentMonth)
        let month = NSCalendar.currentCalendar().component(NSCalendarUnit.MonthCalendarUnit, fromDate: calendar.currentMonth)
        
        fetchMarkedDaysForCurrentYearMonth(year, month: month)
        calendar.markDates(markedDays, withColors: markedColors)
    }

    func dayIsMarked(day: Int) -> Bool {
        for m in markedDays {
            if(m == day){
                return true
            }
        }
        return false
    }
    
    func selectButtonFromMarkedDate(day: Int){
        for (var i = 0; i < markedDays.count; ++i) {
            if(markedDays[i] == day){
                if(markedColors[i] == UIColor.greenColor()){
                    greenBtn.selected = true
                }else if(markedColors[i] == UIColor.yellowColor()){
                    yellowBtn.selected = true
                }else{
                    redBtn.selected = true
                }
            }
        }
    }
    
    //Button functions
    @IBAction func greenBtnPressed(sender: AnyObject) {
        greenBtn.selected = !greenBtn.selected
        yellowBtn.selected = false
        redBtn.selected = false
        
        if let selectedDate = calendar.selectedDate {
            if(dayIsMarked(NSCalendar.currentCalendar().component(NSCalendarUnit.DayCalendarUnit, fromDate: selectedDate))){
                deleteEntriesAtDay(NSCalendar.currentCalendar().component(NSCalendarUnit.DayCalendarUnit, fromDate: selectedDate))
            }
            if(greenBtn.selected){
                let newItem = MarkedDate.createInManagedObjectContext(self.managedObjectContext!, date: selectedDate, markedAs: "green")
            }
            markCalendarWithCoreData()
            calendar.reloadInputViews()
        }
    }
    @IBAction func yellowBtnPressed(sender: AnyObject) {
        yellowBtn.selected = !yellowBtn.selected
        greenBtn.selected = false
        redBtn.selected = false
        
        if let selectedDate = calendar.selectedDate {
            if(dayIsMarked(NSCalendar.currentCalendar().component(NSCalendarUnit.DayCalendarUnit, fromDate: selectedDate))){
                deleteEntriesAtDay(NSCalendar.currentCalendar().component(NSCalendarUnit.DayCalendarUnit, fromDate: selectedDate))
            }
            if(yellowBtn.selected){
                let newItem = MarkedDate.createInManagedObjectContext(self.managedObjectContext!, date: selectedDate, markedAs: "yellow")
            }
            markCalendarWithCoreData()
            calendar.reloadInputViews()
        }
    }
    @IBAction func redBtnPressed(sender: AnyObject) {
        redBtn.selected = !redBtn.selected
        greenBtn.selected = false
        yellowBtn.selected = false
        
        if let selectedDate = calendar.selectedDate {
            if(dayIsMarked(NSCalendar.currentCalendar().component(NSCalendarUnit.DayCalendarUnit, fromDate: selectedDate))){
                deleteEntriesAtDay(NSCalendar.currentCalendar().component(NSCalendarUnit.DayCalendarUnit, fromDate: selectedDate))
            }
            if(redBtn.selected){
                let newItem = MarkedDate.createInManagedObjectContext(self.managedObjectContext!, date: selectedDate, markedAs: "red")
            }
            markCalendarWithCoreData()
            calendar.reloadInputViews()
        }
    }
}




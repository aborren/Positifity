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
        if let managedObjectContext = CoreDataStack().managedObjectContext {
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
    
    var calendarRows: Int = 0
    
    //Button outlets
    @IBOutlet var calendarViewHeight: NSLayoutConstraint!
    
    @IBOutlet var bottomLabel: UILabel!
    @IBOutlet var calView: VRGCalendarView!
    @IBOutlet var greenBtn: UIButton!
    @IBOutlet var yellowBtn: UIButton!
    @IBOutlet var redBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //calendar
        self.calendar.delegate = self
        self.calView.addSubview(calendar)
        self.calendarViewHeight.constant =  calendar.frame.height
        markCalendarWithCoreData()
        calendar.reloadInputViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.managedObjectContext?.save(nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        calendar.reloadInputViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        markCalendarWithCoreData()
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
        
        self.managedObjectContext?.save(nil)
    }
    
    //Calendar delegate functions
    func calendarView(calendarView: VRGCalendarView!, dateSelected date: NSDate!) {
       
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
        //ensure smooth transition of calview
        var updateViewDelay: Double = 0
        if(calendarViewHeight.constant < CGFloat(targetHeight)){
            updateViewDelay = 0.35
        }
        NSTimer.scheduledTimerWithTimeInterval(updateViewDelay, target: self, selector: "updateCalendarViewHeight:", userInfo: targetHeight, repeats: false)
        
        markCalendarWithCoreData()
    }
    
    //
    func updateCalendarViewHeight(timer: NSTimer){
        self.calendarViewHeight.constant = CGFloat(timer.userInfo as Float)
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
                self.managedObjectContext?.save(nil)
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
                self.managedObjectContext?.save(nil)
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
                self.managedObjectContext?.save(nil)
            }
            markCalendarWithCoreData()
            calendar.reloadInputViews()
        }
    }
}




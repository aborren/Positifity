//
//  TodayViewController.swift
//  PositifityWidget
//
//  Created by Dan Isacson on 28/10/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData

class TodayViewController: UIViewController, NCWidgetProviding {
    //Core data
    lazy var managedObjectContext : NSManagedObjectContext? = {
        if let managedObjectContext = CoreDataStack().managedObjectContext {
            return managedObjectContext
        }
        else {
            return nil
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        setupUI()
        
        self.preferredContentSize.height = 175
    }
    
    //Setup UI
    func setupUI(){
        if(self.isDayMarked()){
            setQuoteLabel()
            hideAllButtons()
        }else{
            dismissQuoteLabel()
            showAllButtons()
        }
        
        markLastFiveDays()
        
        self.currentStreakLabel.text = "Current streak: \(calculateCurrentStreak()) days"
        self.bestStreakLabel.text = "Best streak: \(calculateBestStreak()) days"
    }
    
    func setQuoteLabel(){
        self.quoteLabelHeight.constant = 90
        if(UIScreen.mainScreen().bounds.width > 320){
            self.quoteLabelWidth.constant = 240
        }
        self.textLabel.text = Quotes.randomQuote()
    }
    
    func dismissQuoteLabel(){
        self.quoteLabelHeight.constant = 32
        self.quoteLabelWidth.constant = 196
        self.textLabel.text = "How well did you do today?"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    //outlets
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var greenBtn: UIButton!
    @IBOutlet var yellowBtn: UIButton!
    @IBOutlet var redBtn: UIButton!
    @IBOutlet var quoteLabelHeight: NSLayoutConstraint!
    @IBOutlet var quoteLabelWidth: NSLayoutConstraint!
    
    @IBOutlet var day1Image: UIImageView!
    @IBOutlet var day2Image: UIImageView!
    @IBOutlet var day3Image: UIImageView!
    @IBOutlet var day4Image: UIImageView!
    @IBOutlet var day5Image: UIImageView!
    
    @IBOutlet var currentStreakLabel: UILabel!
    @IBOutlet var bestStreakLabel: UILabel!
    
    @IBAction func BtnClick(sender: AnyObject) {
        var color: String?
        if(sender as UIButton == greenBtn){
            color = "green"
        }else if(sender as UIButton == yellowBtn){
            color = "yellow"
        }else if(sender as UIButton == redBtn){
            color = "red"
        }
        if let c = color {/*
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *comps = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay fromDate:self.currentMonth];
            [comps setDay:date];
            self.selectedDate = [gregorian dateFromComponents:comps];*/
            
            let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let components = calendar.components(NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit, fromDate: NSDate())
            let date = calendar.dateFromComponents(components)!
            let newItem = MarkedDate.createInManagedObjectContext(self.managedObjectContext!, date: date, markedAs: c)
            self.managedObjectContext?.save(nil)
            hideAllButtons()
            setupUI()
        }
    }
    
    func hideAllButtons(){
        self.greenBtn.hidden = true
        self.yellowBtn.hidden = true
        self.redBtn.hidden = true
    }
    
    func showAllButtons(){
        self.greenBtn.hidden = false
        self.yellowBtn.hidden = false
        self.redBtn.hidden = false
    }
    
    // Opens main application
    @IBAction func openApp(sender: AnyObject) {
        let url = NSURL(string: "positifity://")
        self.extensionContext?.openURL(url!, completionHandler: nil)
    }
    
    func isDayMarked()->Bool{
        let currentDate = NSDate()
        let year = NSCalendar.currentCalendar().component(NSCalendarUnit.YearCalendarUnit, fromDate: currentDate)
        let month = NSCalendar.currentCalendar().component(NSCalendarUnit.MonthCalendarUnit, fromDate: currentDate)
        let day = NSCalendar.currentCalendar().component(NSCalendarUnit.DayCalendarUnit, fromDate: currentDate)
        
        let fetchRequest = NSFetchRequest(entityName: "MarkedDate")
        let fromDate = CalendarUtility.dateFromComponents(day, month: month, year: year)!
        let toDate = CalendarUtility.dateFromComponents(day+1, month: month, year: year)!
        let predicate = NSPredicate(format: "date >= %@ && date < %@", fromDate, toDate)
        fetchRequest.predicate = predicate
        
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [MarkedDate] {
            if(fetchResults.count > 0){
                return true
            }
        }
        
        return false
    }
    
    func colorForDay(date: NSDate)->String{
        let year = NSCalendar.currentCalendar().component(NSCalendarUnit.YearCalendarUnit, fromDate: date)
        let month = NSCalendar.currentCalendar().component(NSCalendarUnit.MonthCalendarUnit, fromDate: date)
        let day = NSCalendar.currentCalendar().component(NSCalendarUnit.DayCalendarUnit, fromDate: date)
        
        let fetchRequest = NSFetchRequest(entityName: "MarkedDate")
        let fromDate = CalendarUtility.dateFromComponents(day, month: month, year: year)!
        let toDate = CalendarUtility.dateFromComponents(day+1, month: month, year: year)!
        let predicate = NSPredicate(format: "date >= %@ && date < %@", fromDate, toDate)
        fetchRequest.predicate = predicate
        
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [MarkedDate] {
            if(fetchResults.count > 0){
                return fetchResults[0].markedAs
            }
        }
        
        return "no color"
    }
    
    func markLastFiveDays(){
        let currentDate = NSDate()
        let timeIntervalInSecondsForOneDay: Double = 60*60*24
        drawCircleOnImageView(day5Image, color: colorForDay(currentDate))
        drawCircleOnImageView(day4Image, color: colorForDay(currentDate.dateByAddingTimeInterval(timeIntervalInSecondsForOneDay*(-1))))
        drawCircleOnImageView(day3Image, color: colorForDay(currentDate.dateByAddingTimeInterval(timeIntervalInSecondsForOneDay*(-2))))
        drawCircleOnImageView(day2Image, color: colorForDay(currentDate.dateByAddingTimeInterval(timeIntervalInSecondsForOneDay*(-3))))
        drawCircleOnImageView(day1Image, color: colorForDay(currentDate.dateByAddingTimeInterval(timeIntervalInSecondsForOneDay*(-4))))
    }
    
    //Might be slow on high streaks due to CoreData access
    func calculateCurrentStreak()->Int{
        /*var date = NSDate()
        let timeIntervalInSecondsForOneDay: Double = 60*60*24
        
        var streak: Int = 0

        while(colorForDay(date) == "green"){
            streak++
            date = date.dateByAddingTimeInterval(timeIntervalInSecondsForOneDay*(-1))
        }
        
        //check max streak?
        
        return streak*/
        
        
        
        //
        let currentDate = NSDate()
        let fetchRequest = NSFetchRequest(entityName: "MarkedDate")
        let predicate = NSPredicate(format: "date < %@", currentDate)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let timeIntervalInSecondsForOneDay: Double = 60*60*25//DST!
        var streak: Int = 0
        var lastMarkedDay: NSDate?
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [MarkedDate] {
            for f in fetchResults{
                if(lastMarkedDay == nil){
                    if(f.markedAs != "green"){
                        return streak
                    }else{
                        streak++
                        lastMarkedDay = f.date
                    }
                }else{
                    if(f.markedAs == "green"){
                        if(lastMarkedDay!.timeIntervalSinceDate(f.date) <= timeIntervalInSecondsForOneDay){
                            streak++
                            lastMarkedDay = f.date
                        }else{
                            return streak
                        }
                    }else {
                        return streak
                    }
                }
            }
        }
        return streak
    }
    
    func calculateBestStreak()->Int{
        let currentDate = NSDate()
        let fetchRequest = NSFetchRequest(entityName: "MarkedDate")
        let predicate = NSPredicate(format: "date < %@", currentDate)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let timeIntervalInSecondsForOneDay: Double = 60*60*25 //DST!
        var maxStreak: Int = 0
        var streak: Int = 0
        var lastGreenMarkedDay: NSDate?
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [MarkedDate] {
            for f in fetchResults{
                if(lastGreenMarkedDay==nil){
                    //körs till första gången vi stöter på grönmarkerad dag
                    if(f.markedAs == "green"){
                        lastGreenMarkedDay = f.date
                        streak = 1
                        if(streak > maxStreak){
                            maxStreak = streak
                        }
                    }
                }else{
                    //nu har vi en grönmarkerad dag
                    if(f.markedAs == "green"){
                        if(f.date.timeIntervalSinceDate(lastGreenMarkedDay!) <= timeIntervalInSecondsForOneDay){
                            streak += 1
                            if(streak > maxStreak){
                                maxStreak = streak
                            }
                        }else{
                            streak = 1
                        }
                        lastGreenMarkedDay = f.date
                    }else {
                        streak = 0
                    }
                }
            }
        }
        return maxStreak
    }
    
    func drawCircleOnImageView(imageView: UIImageView, color: String){
        if(color == "green"){
            imageView.image = UIImage(named: "dot_green.png")
        }else if(color == "yellow"){
            imageView.image = UIImage(named: "dot_yellow.png")
        }else if(color == "red"){
            imageView.image = UIImage(named: "dot_red.png")
        }else{
            imageView.image = UIImage(named: "gray_dot.png")
        }
    }    
}

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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        setupUI()
        
        self.preferredContentSize.height = 175
    }
    
    //Setup UI
    func setupUI(){
        if(self.isDayMarked()){
            self.textLabel.text = "POSITIVE QUOTE"
            self.greenBtn.hidden = true
        }else{
            self.textLabel.text = "Click it if you progressed!"
            self.greenBtn.hidden = false
        }
        
        markLastFiveDays()
        
        self.currentStreakLabel.text = "Current streak: \(calculateCurrentStreak()) days"
        self.bestStreakLabel.text = "Best streak: \(calculateBestStreak()) (TODO)"
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
    
    @IBOutlet var day1Image: UIImageView!
    @IBOutlet var day2Image: UIImageView!
    @IBOutlet var day3Image: UIImageView!
    @IBOutlet var day4Image: UIImageView!
    @IBOutlet var day5Image: UIImageView!
    
    @IBOutlet var currentStreakLabel: UILabel!
    @IBOutlet var bestStreakLabel: UILabel!
    
    @IBAction func greenBtnClick(sender: AnyObject) {
        //kanske om man vill skriva nåt från NSDEF
        /*var d = NSUserDefaults(suiteName: "group.dna.positifity")?.doubleForKey("test")
        NSUserDefaults(suiteName: "group.dna.positifity")?.setDouble(d!+1.0, forKey: "test")
        TestLabel.text = NSUserDefaults(suiteName: "group.dna.positifity")?.doubleForKey("test").description*/

        let newItem = MarkedDate.createInManagedObjectContext(self.managedObjectContext!, date: NSDate(), markedAs: "green")
        self.saveContext()

        greenBtn.hidden = true
        setupUI()
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
        var date = NSDate()
        let timeIntervalInSecondsForOneDay: Double = 60*60*24
        
        var streak: Int = 0

        while(colorForDay(date) == "green"){
            streak++
            date = date.dateByAddingTimeInterval(timeIntervalInSecondsForOneDay*(-1))
        }
        
        //check max streak?
        
        return streak
    }
    
    func calculateBestStreak()->Int{
        return 0
    }
    
    func drawCircleOnImageView(imageView: UIImageView, color: String){
        if(color == "green"){
            imageView.image = UIImage(named: "dot_green.png")
        }else if(color == "yellow"){
            imageView.image = UIImage(named: "dot_yellow.png")
        }else if(color == "red"){
            imageView.image = UIImage(named: "dot_red.png")
        }else{
            //imageView.image = UIImage(named: "posi_logo.png")
        }
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "dna.Positifity" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Positifity", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        //let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Positifity.sqlite")
        let url = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.dna.positifity")?.URLByAppendingPathComponent("Positifity.sqlite")
        
        
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
}

//
//  StartPageDefaultViewController.swift
//  Positifity
//
//  Created by Dan Isacson on 17/12/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit
import HealthKit

class StartPageDefaultViewController: UIViewController, UIPageViewControllerDataSource {

    @IBOutlet var heightConstraint: NSLayoutConstraint!
    var pageTexts: [String] = ["Welcome to Positifity, the small yet powerful tool to help you stay motivated towards your fitness goals! ",
        "Mark the calendar with green dots on the days you did something positive towards your goal. Do this once every day and keep racking up green dots.",
        "If your device has iOS8 or higher you can use the Positifity widget to mark your calendar. Don't break the chain!",
        "As you do this you'll most certainly make some progress towards your weight goals. Positifity helps you update and keep track of this."]
    var pageImages: [String] = ["posicircle.png", "calendar.png", "widget.png", "progress.png"]
    var pageViewController: UIPageViewController!
    var pageContentViewControllers: [StartPageContentViewController] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(HelperFunctions.isAboveIOSVersion("8.0")){
            self.requestPermissions()
        }
        
        self.pageViewController = storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as UIPageViewController
        self.pageViewController.dataSource = self
        
        //instantiate all viewcontrollers
        for(var i = 0; i < pageTexts.count; i++){
            var pageContentViewController: StartPageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageContentController") as StartPageContentViewController
            pageContentViewController.text = self.pageTexts[i]
            pageContentViewController.imageName = self.pageImages[i]
            pageContentViewController.index = i
            pageContentViewControllers.append(pageContentViewController)
        }
        
        var startingViewController: StartPageContentViewController = self.viewControllerAtIndex(0)!
        var viewControllers = [startingViewController]
        self.pageViewController.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - heightConstraint.constant)
        
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index: Int = (viewController as StartPageContentViewController).index
        if(index == NSNotFound){
            return nil
        }
        index++
        if(index >= self.pageContentViewControllers.count){
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index: Int = (viewController as StartPageContentViewController).index
        
        if((index == 0) || (index == NSNotFound)){
            return nil
        }
        index--
        return self.viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index: Int)->StartPageContentViewController?{
        if((self.pageContentViewControllers.count == 0) || (index >= self.pageContentViewControllers.count)){
            return nil
        }
        var pageContentViewController: StartPageContentViewController = pageContentViewControllers[index]
        return pageContentViewController
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageContentViewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func requestPermissions(){
        //leave if healthkit not available
        if(!HKHealthStore.isHealthDataAvailable()){
            return
        }
        let dataTypesToWrite = [HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)]
        let dataTypesToRead = [
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        ]
        
        var appDel = UIApplication.sharedApplication().delegate as AppDelegate
        appDel.healthStore.requestAuthorizationToShareTypes(NSSet(array: dataTypesToWrite), readTypes: NSSet(array: dataTypesToRead), completion: {
            (success, error) in
            if success {
                println("User completed authorisation request.")
            } else {
                println("The user cancelled the authorisation request. \(error)")
            }
            }
        )
    }

}

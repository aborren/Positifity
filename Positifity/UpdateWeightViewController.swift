//
//  UpdateWeightViewController.swift
//  Positifity
//
//  Created by Dan Isacson on 21/10/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit
import HealthKit
import iAd

class UpdateWeightViewController: UIViewController, ADBannerViewDelegate {

    @IBOutlet var newWeightTextField: UITextField!
    var adIsVisible = false
    var ad: ADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        ad = ADBannerView(frame: CGRectMake(0, self.view.frame.size.height, self.view.frame.width, 50))
        ad.delegate = self
    }
    
    //Ads
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        if(!adIsVisible){
            if(ad.superview == nil){
                self.view.addSubview(ad)
            }
            UIView.beginAnimations("ShowAdAnimation", context: nil)
            ad.frame = CGRectOffset(ad.frame, 0, -ad.frame.size.height)
            UIView.commitAnimations()
            adIsVisible = true
        }
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        println("failed to load AD")
        if(adIsVisible){
            UIView.beginAnimations("HideAdAnimation", context: nil)
            ad.frame = CGRectOffset(ad.frame, 0, ad.frame.size.height)
            UIView.commitAnimations()
            adIsVisible = false
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(segue.identifier=="saveWeightUpdate"){
            updateWeight()
        }
    }

    func updateWeight(){
        if let weight = HelperFunctions.numberString(newWeightTextField.text){
            if(HelperFunctions.isAboveIOSVersion("8.0")){
                saveWeightToHealthKit(weight)
            }
            NSUserDefaults.standardUserDefaults().setDouble(weight, forKey: "weight")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func saveWeightToHealthKit(weight: Double){
        if(!HKHealthStore.isHealthDataAvailable()){
            return
        }
        //Check unit type. Default Kilograms, but change if set to Pounds or Stones
        var unitType = HKUnit.gramUnitWithMetricPrefix(HKMetricPrefix.Kilo)
        if let weightUnit = NSUserDefaults.standardUserDefaults().stringForKey("weightUnit"){
            if(weightUnit == "Pounds"){
                unitType = HKUnit.poundUnit()
            }else if(weightUnit == "Stones"){
                unitType = HKUnit.stoneUnit()
            }
        }
        let weightQuantity = HKQuantity(unit: unitType, doubleValue: weight)
        let weightType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        let currentDate = NSDate()
        let weightSample = HKQuantitySample(type: weightType, quantity: weightQuantity, startDate: currentDate, endDate: currentDate)
        
        let appDel = UIApplication.sharedApplication().delegate as AppDelegate
        appDel.healthStore.saveObject(weightSample, withCompletion: {
            (success, error) in
            if(!success){
                println("An error occured\(error)")
            }
            })
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
}

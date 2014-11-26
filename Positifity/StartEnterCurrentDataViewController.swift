//
//  StartEnterCurrentDataViewController.swift
//  Positifity
//
//  Created by Dan Isacson on 20/10/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit
import HealthKit

class StartEnterCurrentDataViewController: UIViewController {

    @IBOutlet var weightTextView: UITextField!
    @IBOutlet var weightUnitSegmentedControl: UISegmentedControl!
    
    @IBOutlet var heightTextView: UITextField!
    @IBOutlet var heightUnitSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.perfromQueryForWeightSamples()
        self.perfromQueryForHeightSamples()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func perfromQueryForWeightSamples() {
        let weightSampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        let sortDesc: NSSortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: weightSampleType, predicate: nil,
            limit: 1, sortDescriptors: [sortDesc], resultsHandler: {
                (query, results, error) in
                if !(results != nil) {
                    println("There was an error running the query: \(error)")
                }
                dispatch_async(dispatch_get_main_queue()) {
                    var res = results as [HKQuantitySample]
                    for s in res {
                        let hk: HKQuantitySample = s as HKQuantitySample
                        //println(hk.description)
                        let weight: Double = hk.quantity.doubleValueForUnit(HKUnit(fromString: "kg"))
                        self.weightTextView.text = weight.description
                    }
                }
        })
        var appDel = UIApplication.sharedApplication().delegate as AppDelegate
        appDel.healthStore.executeQuery(query)
    }
    
    func perfromQueryForHeightSamples() {
        let heightSampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)
        let sortDesc: NSSortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: heightSampleType, predicate: nil,
            limit: 1, sortDescriptors: [sortDesc], resultsHandler: {
                (query, results, error) in
                if !(results != nil) {
                    println("There was an error running the query: \(error)")
                }
                dispatch_async(dispatch_get_main_queue()) {
                    var res = results as [HKQuantitySample]
                    for s in res {
                        let hk: HKQuantitySample = s as HKQuantitySample
                        //println(hk.description)
                        let height: Double = hk.quantity.doubleValueForUnit(HKUnit(fromString: "cm"))
                        self.heightTextView.text = height.description
                    }
                }
        })
        let appDel = UIApplication.sharedApplication().delegate as AppDelegate
        appDel.healthStore.executeQuery(query)
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

    // MARK: - Navigation
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject?) -> Bool {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let weight = HelperFunctions.numberString(weightTextView.text){
            NSUserDefaults.standardUserDefaults().setDouble(weight, forKey: "startWeight")
            NSUserDefaults.standardUserDefaults().setDouble(weight, forKey: "weight")
            NSUserDefaults.standardUserDefaults().setValue(weightUnitSegmentedControl.titleForSegmentAtIndex(weightUnitSegmentedControl.selectedSegmentIndex), forKey: "weightUnit")

        }else{
            return false
            //inte gå nästa steg
        }
        
        if let height = HelperFunctions.numberString(heightTextView.text){
            NSUserDefaults.standardUserDefaults().setDouble(height, forKey: "height")
            NSUserDefaults.standardUserDefaults().setObject(heightUnitSegmentedControl.titleForSegmentAtIndex(heightUnitSegmentedControl.selectedSegmentIndex), forKey: "heightUnit")
        }else{
            return false
            //inte gå nästa steg
        }
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isSetup")
        NSUserDefaults.standardUserDefaults().synchronize()
        return true
    }
}

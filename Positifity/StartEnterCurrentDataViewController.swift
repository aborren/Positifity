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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        //sätt start weight i nsuserdef
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
        
        //sätt height i nsuserdef
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    //MARK: Utility functions
    func numberString(input: String) -> Double? {
        let formatter = NSNumberFormatter()
        var result: Double? = nil
        let parsed = formatter.numberFromString(input)
        if let parsed = parsed {
            result = parsed as Double
        }
        return result
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {

    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let weight = numberString(weightTextView.text){
            NSUserDefaults.standardUserDefaults().setDouble(weight, forKey: "weight")
            NSUserDefaults.standardUserDefaults().setValue(weightUnitSegmentedControl.titleForSegmentAtIndex(weightUnitSegmentedControl.selectedSegmentIndex), forKey: "weightUnit")

        }else{
            return false
            //inte gå nästa steg
        }
        
        if let height = numberString(heightTextView.text){
            NSUserDefaults.standardUserDefaults().setDouble(height, forKey: "height")
            NSUserDefaults.standardUserDefaults().setObject(heightUnitSegmentedControl.titleForSegmentAtIndex(heightUnitSegmentedControl.selectedSegmentIndex), forKey: "heightUnit")
        }else{
            return false
            //inte gå nästa steg
        }
        
        NSUserDefaults.standardUserDefaults().synchronize()
        return true
    }
}

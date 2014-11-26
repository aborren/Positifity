//
//  UpdateWeightViewController.swift
//  Positifity
//
//  Created by Dan Isacson on 21/10/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit
import HealthKit

class UpdateWeightViewController: UIViewController {

    @IBOutlet var newWeightTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(segue.identifier=="saveWeightUpdate"){
            updateWeight()
        }
    }

    func updateWeight(){
        if let weight = HelperFunctions.numberString(newWeightTextField.text){
            saveWeightToHealthKit(weight)
            NSUserDefaults.standardUserDefaults().setDouble(weight, forKey: "weight")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func saveWeightToHealthKit(weight: Double){
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
}

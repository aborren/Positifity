//
//  SettingsViewController.swift
//  Positifity
//
//  Created by Dan Isacson on 21/10/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var newGoalTextField: UITextField!
    @IBOutlet var heightTextField: UITextField!
    @IBOutlet var weightTextField: UITextField!
    @IBOutlet var weightUnitSegmentedControl: UISegmentedControl!
    @IBOutlet var heightUnitSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadValues()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadValues(){
        newGoalTextField.text = NSUserDefaults.standardUserDefaults().doubleForKey("goal").description
        heightTextField.text = NSUserDefaults.standardUserDefaults().doubleForKey("height").description
        weightTextField.text = NSUserDefaults.standardUserDefaults().doubleForKey("startWeight").description
        
        if let weightUnit = NSUserDefaults.standardUserDefaults().stringForKey("weightUnit"){
            if(weightUnit == "Pounds"){
                weightUnitSegmentedControl.selectedSegmentIndex = 2
            }else if(weightUnit == "Stones"){
                weightUnitSegmentedControl.selectedSegmentIndex = 1
            }else{
                weightUnitSegmentedControl.selectedSegmentIndex = 0
            }
        }
        
        if let heightUnit = NSUserDefaults.standardUserDefaults().stringForKey("heightUnit"){
            if(heightUnit == "Feet"){
                heightUnitSegmentedControl.selectedSegmentIndex = 2
            }else if(heightUnit == "Inches"){
                heightUnitSegmentedControl.selectedSegmentIndex = 1
            }else{
                heightUnitSegmentedControl.selectedSegmentIndex = 0
            }
        }
    }
    
    func saveValues(){
        if let goal = HelperFunctions.numberString(newGoalTextField.text){
            NSUserDefaults.standardUserDefaults().setDouble(goal, forKey: "goal")
        }
        if let height = HelperFunctions.numberString(heightTextField.text){
            NSUserDefaults.standardUserDefaults().setDouble(height, forKey: "height")
        }
        if let startWeight = HelperFunctions.numberString(weightTextField.text){
            NSUserDefaults.standardUserDefaults().setDouble(startWeight, forKey: "startWeight")
        }

        NSUserDefaults.standardUserDefaults().setValue(weightUnitSegmentedControl.titleForSegmentAtIndex(weightUnitSegmentedControl.selectedSegmentIndex), forKey: "weightUnit")
        
        NSUserDefaults.standardUserDefaults().setObject(heightUnitSegmentedControl.titleForSegmentAtIndex(heightUnitSegmentedControl.selectedSegmentIndex), forKey: "heightUnit")
        
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(segue.identifier == "saveSettingSegue"){
            saveValues()
        }
    }
    

}

//
//  ProgressViewController.swift
//  Positifity
//
//  Created by Dan Isacson on 18/10/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit
import HealthKit

class ProgressViewController: UIViewController {

    @IBOutlet var goalWeightLabel: UILabel!
    @IBOutlet var circle: SAMultisectorControl!
    @IBOutlet var descriptionLabel: UILabel!
    
    var goalWeight: Double = 0
    var goalPercentage: Double = 0
    
    var weightLoss: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer
        setupCircle()
        loadWeightText()
    
        //Setup timer for changing goalweight/progress % transition
        NSTimer.scheduledTimerWithTimeInterval(6.0, target: self, selector: "transition", userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCircle(){
        //nollställ
        self.circle.removeAllSectors()
        
        var startWeight = NSUserDefaults.standardUserDefaults().doubleForKey("startWeight")
        var goalWeight = NSUserDefaults.standardUserDefaults().doubleForKey("goal")
        var currentWeight = NSUserDefaults.standardUserDefaults().doubleForKey("weight")
        
        //if losing weight or gaining or none
        weightLoss = startWeight - goalWeight
        
        //self.circle.addTarget(self, action: "multisectorValueChanged", forControlEvents: UIControlEvents.ValueChanged)
        self.circle.userInteractionEnabled = false
        
        var sector : SAMultisectorSector
        
        if(weightLoss > 0){
            if(startWeight <= currentWeight){
                startWeight = currentWeight + 0.01  //fulhack för sector..
            }
            sector = SAMultisectorSector(color: UIColor(hexString: "009dd0"), minValue: -startWeight, maxValue: -goalWeight)
            sector.endValue = -currentWeight
            sector.startValue = -startWeight
        }else if(weightLoss < 0){
            if(startWeight >= currentWeight){
                startWeight = currentWeight - 0.01 //fulhack för sector..
            }
            sector = SAMultisectorSector(color: UIColor(hexString: "009dd0"), minValue: startWeight, maxValue: goalWeight)
            sector.endValue = currentWeight
            sector.startValue = startWeight
        }else{
            sector = SAMultisectorSector(color: UIColor(hexString: "009dd0"), minValue: startWeight, maxValue: goalWeight+0.01) //fulhack för sector..
            sector.endValue = goalWeight+0.01 //fulhack för sector..
            sector.startValue = startWeight
        }

        self.circle.addSector(sector)        
    }
    
   /* func multisectorValueChanged(){
        self.updateDataView()
    }
    
    func updateDataView(){
        
    }*/

    func loadWeightText(){
       goalWeight = NSUserDefaults.standardUserDefaults().doubleForKey("goal")
        var startWeight = NSUserDefaults.standardUserDefaults().doubleForKey("startWeight")
        var currentWeight = NSUserDefaults.standardUserDefaults().doubleForKey("weight")
        if(weightLoss > 0){
            if(startWeight < currentWeight){
                goalPercentage = 0
            }else{
                goalPercentage = (startWeight - currentWeight)/(startWeight - goalWeight) * 100
            }
        }else if(weightLoss < 0){
            if(startWeight > currentWeight){
                goalPercentage = 0
            }
            else{
                goalPercentage = (currentWeight - startWeight)/(goalWeight - startWeight) * 100
            }
        }
        else{
            goalPercentage = 100
        }
        //println("Start: \(startWeight) Current: \(currentWeight) Goal: \(goalWeight) WeightLoss=\(weightLoss)")
        descriptionLabel.text = "Goal weight"
        goalWeightLabel.text = NSUserDefaults.standardUserDefaults().doubleForKey("goal").description + currentWeightUnitAbbrevation()
    }
    
    func setupAnimation(){
        let anim: CATransition = CATransition()
        anim.duration = 1.2
        anim.type = kCATransitionFade
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        anim.removedOnCompletion = false
        goalWeightLabel.layer.addAnimation(anim, forKey: "changeTextTransition")
        descriptionLabel.layer.addAnimation(anim, forKey: "descriptionTextTransition")
    }
    
    func transition(){
        setupAnimation()
        if(self.goalWeightLabel.text == goalWeight.description + currentWeightUnitAbbrevation()){
            self.descriptionLabel.text = "Progress"
            self.goalWeightLabel.text = NSString(format: "%.0f", goalPercentage) + "%"
        }
        else{
            self.descriptionLabel.text = "Goal weight"
            self.goalWeightLabel.text = goalWeight.description + currentWeightUnitAbbrevation()
        }
    }
    
    func currentWeightUnitAbbrevation()->String{
        if let weightUnit = NSUserDefaults.standardUserDefaults().stringForKey("weightUnit"){
            if(weightUnit == "Pounds"){
               return "lb"
            }else if(weightUnit == "Stones"){
                return "st"
            }else{
                return "kg"
            }
        }
        return ""
    }
    
    @IBAction func unwindToSegue (segue : UIStoryboardSegue) {
        self.setupCircle()
        loadWeightText()
    }
    
    @IBAction func updateOrSetting(sender: AnyObject) {
        if(weightLoss == 0){
            performSegueWithIdentifier("settings", sender: sender)
        }else{
            performSegueWithIdentifier("update", sender: sender)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

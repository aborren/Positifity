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

    @IBOutlet var currentWeight: UILabel!
    @IBOutlet var goalWeight: UILabel!
    @IBOutlet var circle: SAMultisectorControl!
    
    var weightLoss: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer
        setupCircle()
        loadWeightText()

        // Do any additional setup after loading the view.
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
        
        //if losing weight or gaining
        weightLoss = (startWeight - goalWeight > 0)
        self.circle.addTarget(self, action: "multisectorValueChanged", forControlEvents: UIControlEvents.ValueChanged)
        self.circle.userInteractionEnabled = false
        
        var sector : SAMultisectorSector
        if(weightLoss){
            if(startWeight <= currentWeight){
                startWeight = currentWeight + 0.01  //fulhack för sector..
            }
            sector = SAMultisectorSector(color: UIColor(hexString: "009dd0"), minValue: -startWeight, maxValue: -goalWeight)
            sector.endValue = -currentWeight
            sector.startValue = -startWeight
        }else{
            if(startWeight >= currentWeight){
                startWeight = currentWeight + 0.01 //fulhack för sector..
            }
            sector = SAMultisectorSector(color: UIColor(hexString: "009dd0"), minValue: startWeight, maxValue: goalWeight)
            sector.endValue = currentWeight
            sector.startValue = startWeight
        }

        self.circle.addSector(sector)
        
    }
    
    func multisectorValueChanged(){
        self.updateDataView()
    }
    
    func updateDataView(){
        
    }

    func loadWeightText(){
        goalWeight.text = NSUserDefaults.standardUserDefaults().doubleForKey("goal").description
        if let wu = NSUserDefaults.standardUserDefaults().stringForKey("weightUnit") {
            if let hu = NSUserDefaults.standardUserDefaults().stringForKey("heightUnit") {
                currentWeight.text = NSUserDefaults.standardUserDefaults().doubleForKey("weight").description + wu + " " + NSUserDefaults.standardUserDefaults().doubleForKey("height").description + hu
            }
        }
    }
    
    @IBAction func unwindToSegue (segue : UIStoryboardSegue) {
        self.setupCircle()
        loadWeightText()
        println(segue.identifier)
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

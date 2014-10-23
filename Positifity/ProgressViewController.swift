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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCircle()
        loadWeightText()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCircle(){
        self.circle.addTarget(self, action: "multisectorValueChanged", forControlEvents: UIControlEvents.ValueChanged)
        self.circle.userInteractionEnabled = false
        
        var sector : SAMultisectorSector = SAMultisectorSector(color: UIColor(hexString: "4ED2C5"), minValue: 0.0, maxValue: 100.0)
        sector.endValue = 25.6
        sector.startValue = 0.0

        self.circle.addSector(sector)
        
    }
    
    func multisectorValueChanged(){
        self.updateDataView()
    }
    
    func updateDataView(){
        //TODO update sector
        loadWeightText()
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
        self.updateDataView()
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

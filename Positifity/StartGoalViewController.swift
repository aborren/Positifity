//
//  StartGoalViewController.swift
//  Positifity
//
//  Created by Dan Isacson on 20/10/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit

class StartGoalViewController: UIViewController {

    @IBOutlet var goalTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if let goalWeight = numberString(goalTextField.text){
            NSUserDefaults.standardUserDefaults().setDouble(goalWeight, forKey: "goal")
        }else{
            //inte gå nästa steg
        }
    }
    
    // MARK: Utility functions
    func numberString(input: String) -> Double? {
        let formatter = NSNumberFormatter()
        var result: Double? = nil
        let parsed = formatter.numberFromString(input) as Double?
        if let parsed = parsed {
            result = parsed
        }
        return result
    }

}

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

    // MARK: - Navigation
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject?) -> Bool {
        if let goalWeight = HelperFunctions.numberString(goalTextField.text){
            println(goalWeight)
            NSUserDefaults.standardUserDefaults().setDouble(goalWeight, forKey: "goal")
            return true
        }else{
            return false
        }
    }
}

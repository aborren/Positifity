//
//  InitialViewController.swift
//  Positifity
//
//  Created by Dan Isacson on 16/12/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    override func viewDidLoad() {
        let storyboard = self.storyboard
        let start: StartViewController = storyboard?.instantiateViewControllerWithIdentifier("start") as StartViewController
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isSetup: Bool = defaults.boolForKey("isSetup") //returns false as default if it doesn't exist
        if(!isSetup){
            self.presentViewController(start, animated: true, completion: nil)
        }

    }
}

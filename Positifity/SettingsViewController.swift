//
//  SettingsViewController.swift
//  Positifity
//
//  Created by Dan Isacson on 21/10/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    var test = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(segue.identifier == "saveSettingSegue"){
            print("decisions..")
        }
    }
    

}

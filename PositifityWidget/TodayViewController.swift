//
//  TodayViewController.swift
//  PositifityWidget
//
//  Created by Dan Isacson on 28/10/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet var TestLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        TestLabel.text = NSUserDefaults(suiteName: "group.dna.positifity")?.doubleForKey("test").description
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
    @IBAction func test(sender: AnyObject) {
        var d = NSUserDefaults(suiteName: "group.dna.positifity")?.doubleForKey("test")
        NSUserDefaults(suiteName: "group.dna.positifity")?.setDouble(d!+1.0, forKey: "test")
        TestLabel.text = NSUserDefaults(suiteName: "group.dna.positifity")?.doubleForKey("test").description

    }
}

//
//  StartViewController.swift
//  Positifity
//
//  Created by Dan Isacson on 20/10/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit
import HealthKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        requestPermissions()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func requestPermissions(){
        let dataTypesToWrite = [HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)]
        let dataTypesToRead = [
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass),
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMassIndex),
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)
        ]
        
        var appDel = UIApplication.sharedApplication().delegate as AppDelegate
        appDel.healthStore.requestAuthorizationToShareTypes(NSSet(array: dataTypesToWrite), readTypes: NSSet(array: dataTypesToRead), completion: {
            (success, error) in
            if success {
                println("User completed authorisation request.")
            } else {
                println("The user cancelled the authorisation request. \(error)")
            }
            }
        )
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

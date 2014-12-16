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
        if(HelperFunctions.isAboveIOSVersion("8.0")){
            requestPermissions()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func requestPermissions(){
        let dataTypesToWrite = [HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)]
        let dataTypesToRead = [
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
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
}

//
//  StartPageContentViewController.swift
//  Positifity
//
//  Created by Dan Isacson on 17/12/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit

class StartPageContentViewController: UIViewController {

    @IBOutlet var label: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet var imageWidthConstraint: NSLayoutConstraint!
    
    var text: String?
    var imageName: String?
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.label.hidden = true
        self.label.text = text
        if let imageSource = imageName{
            image.image = UIImage(named: imageSource)
        }
        self.image.hidden = true
        self.imageHeightConstraint.constant = self.view.frame.size.width - 80
        self.imageWidthConstraint.constant = self.view.frame.size.width - 80
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        animation()
        self.label.hidden = false
        self.image.hidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animation(){
        let anim: CATransition = CATransition()
        anim.duration = 1.1
        anim.type = kCATransitionFade
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        anim.removedOnCompletion = false
        label.layer.addAnimation(anim, forKey: "fadeInText")
        image.layer.addAnimation(anim, forKey: "fadeInImage")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

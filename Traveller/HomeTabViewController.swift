//
//  HomeTabViewController.swift
//  Traveller
//
//  Created by Tan Yee Gene on 26/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class HomeTabViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func onLogoutButtonPressed(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userUID")
        let manager = FBSDKLoginManager()
        manager.logOut()
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let viewController = storyboard.instantiateViewControllerWithIdentifier("SignUpViewController")
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    @IBAction func unwindToHomeTabBar(segue: UIStoryboardSegue) {
    }
}

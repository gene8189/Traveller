//
//  RatingViewController.swift
//  Traveller
//
//  Created by Tan Yee Gene on 03/10/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit
import Firebase

class RatingViewController: UIViewController {
    
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var button4: UIButton!
    @IBOutlet var button5: UIButton!
    
    @IBOutlet var travellerProfileImage: UIImageView!
    @IBOutlet var username: UIButton!
    var numberOfStars: Int?
    var travellerID: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        observeTravellerProfile(travellerID!)
        numberOfStars = 0
    }
    
    
    func observeTravellerProfile(travellerID : String){
        DataService.usernameRef.child(travellerID).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            let traveller = Username(snapshot: snapshot)
            self.username.setTitle("\(traveller!.username)", forState: .Normal)
            let url = NSURL(string: traveller!.profileImage)
            self.travellerProfileImage.sd_setImageWithURL(url, placeholderImage: UIImage(named: "loading"))
            
        })
    }
    
    var pressed1 = false
    @IBAction func onButton1Pressed(sender: AnyObject) {
        if !pressed1 {
            button1.setImage(UIImage(named:"Star" ), forState: .Normal)
            pressed1 = true
            self.numberOfStars = 1
        } else {
            button1.setImage(UIImage(named: "emptyStar"), forState: .Normal)
            pressed1 = false
        }
    }
    
    var pressed2 = false
    @IBAction func onButton2Pressed(sender: AnyObject) {
       
            if !pressed2 {
                button1.setImage(UIImage(named:"Star" ), forState: .Normal)
                button2.setImage(UIImage(named:"Star" ), forState: .Normal)
                pressed2 = true
                self.numberOfStars = 2
            } else {
                button1.setImage(UIImage(named:"emptyStar" ), forState: .Normal)
                button2.setImage(UIImage(named: "emptyStar"), forState: .Normal)
                pressed2 = false
            }
        
    }
    var pressed3 = false
    @IBAction func onButton3Pressed(sender: AnyObject) {
       
            if !pressed3 {
                button1.setImage(UIImage(named:"Star" ), forState: .Normal)
                button2.setImage(UIImage(named:"Star" ), forState: .Normal)
                button3.setImage(UIImage(named:"Star" ), forState: .Normal)
                pressed3 = true
                self.numberOfStars = 3
            } else {
                button1.setImage(UIImage(named:"emptyStar" ), forState: .Normal)
                button2.setImage(UIImage(named:"emptyStar" ), forState: .Normal)
                button3.setImage(UIImage(named: "emptyStar"), forState: .Normal)
                pressed3 = false
            }
        
        
    }
    
    var pressed4 = false
    @IBAction func onButton4Pressed(sender: AnyObject) {
        
            if !pressed4 {
                button1.setImage(UIImage(named:"Star" ), forState: .Normal)
                button2.setImage(UIImage(named:"Star" ), forState: .Normal)
                button3.setImage(UIImage(named:"Star" ), forState: .Normal)
                button4.setImage(UIImage(named:"Star" ), forState: .Normal)
                pressed4 = true
                self.numberOfStars = 4
            } else {
                button1.setImage(UIImage(named:"emptyStar" ), forState: .Normal)
                button2.setImage(UIImage(named:"emptyStar" ), forState: .Normal)
                button3.setImage(UIImage(named:"emptyStar" ), forState: .Normal)
                button4.setImage(UIImage(named: "emptyStar"), forState: .Normal)
                pressed4 = false
            }
        
    }
    
    var pressed5 = false
    @IBAction func onButton5Pressed(sender: AnyObject) {
        
            if !pressed5 {
                button1.setImage(UIImage(named:"Star" ), forState: .Normal)
                button2.setImage(UIImage(named:"Star" ), forState: .Normal)
                button3.setImage(UIImage(named:"Star" ), forState: .Normal)
                button4.setImage(UIImage(named:"Star" ), forState: .Normal)
                button5.setImage(UIImage(named:"Star" ), forState: .Normal)
                pressed5 = true
                self.numberOfStars = 5
            } else {
                button1.setImage(UIImage(named:"emptyStar" ), forState: .Normal)
                button2.setImage(UIImage(named:"emptyStar" ), forState: .Normal)
                button3.setImage(UIImage(named:"emptyStar" ), forState: .Normal)
                button4.setImage(UIImage(named:"emptyStar" ), forState: .Normal)
                button5.setImage(UIImage(named: "emptyStar"), forState: .Normal)
                pressed5 = false
            }
        
        
    }
    @IBAction func onSubmitButtonPressed(sender: AnyObject) {
        DataService.usernameRef.child(travellerID!).updateChildValues(["trustworthy" : self.numberOfStars!])
        
    }
    
    
    
    
}

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
    
    @IBOutlet var textView: UITextView!

    
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var button4: UIButton!
    @IBOutlet var button5: UIButton!
    
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var travellerProfileImage: UIImageView!
    @IBOutlet var username: UIButton!
    var numberOfStars: Int!
    var travellerID: String?
    var postID: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        observeTravellerProfile(travellerID!)
        numberOfStars = 0
        
        
        DataService.postRef.child(self.postID!).child("reviews").observeEventType(.ChildAdded, withBlock: {(snapshot) in
            let userKey = snapshot.key
            if userKey == DataService.currentUserUID {
                self.submitButton.hidden = true
                
                DataService.usernameRef.child(self.travellerID!).child("reviews").child(DataService.currentUserUID).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
                    guard let dict = snapshot.value as? [String: AnyObject] else {return}
                    let dictReview = dict["review"] as? String
                    let dictStarCount = dict["starCount"] as? Int
                    self.textView.text = dictReview
                    
                    if dictStarCount == 0 {
                        self.numberOfStars(0)
                        self.buttonsDisable()
                        
                    } else if dictStarCount == 1{
                        self.numberOfStars(1)
                        self.buttonsDisable()
                    } else if dictStarCount == 2 {
                       self.numberOfStars(2)
                        self.buttonsDisable()
                    }else if dictStarCount == 3 {
                       self.numberOfStars(3)
                       self.buttonsDisable()
                    }else if dictStarCount == 4 {
                        self.numberOfStars(4)
                        self.buttonsDisable()
                    }else if dictStarCount == 5 {
                        self.numberOfStars(5)
                        self.buttonsDisable()
                    }

                })
                
            }
        })
        
    }
    
    func buttonsDisable(){
        self.button1.enabled = false
        self.button2.enabled = false
        self.button3.enabled = false
        self.button4.enabled = false
        self.button5.enabled = false
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
            numberOfStars(1)
            pressed1 = true
            self.numberOfStars = 1
        } else {
            button1.setImage(UIImage(named: "emptyStar"), forState: .Normal)
            button2.setImage(UIImage(named: "emptyStar"), forState: .Normal)
            button3.setImage(UIImage(named: "emptyStar"), forState: .Normal)
            button4.setImage(UIImage(named: "emptyStar"), forState: .Normal)
            button5.setImage(UIImage(named: "emptyStar"), forState: .Normal)

            pressed1 = false
        }
    }
    
//    var pressed2 = false
    @IBAction func onButton2Pressed(sender: AnyObject) {
       
            if !pressed1 {
                numberOfStars(2)
                pressed1 = true
                self.numberOfStars = 2
            } else {
                button1.setImage(UIImage(named:"Star" ), forState: .Normal)
                button2.setImage(UIImage(named: "Star"), forState: .Normal)
                button3.setImage(UIImage(named: "emptyStar"), forState: .Normal)
                button4.setImage(UIImage(named: "emptyStar"), forState: .Normal)
                button5.setImage(UIImage(named: "emptyStar"), forState: .Normal)
                pressed1 = false
            }
        
    }
//    var pressed3 = false
    @IBAction func onButton3Pressed(sender: AnyObject) {
       
            if !pressed1 {
                numberOfStars(3)
                pressed1 = true
                self.numberOfStars = 3
            } else {
                button1.setImage(UIImage(named:"Star" ), forState: .Normal)
                button2.setImage(UIImage(named:"Star" ), forState: .Normal)
                button3.setImage(UIImage(named: "Star"), forState: .Normal)
                button4.setImage(UIImage(named: "emptyStar"), forState: .Normal)
                button5.setImage(UIImage(named: "emptyStar"), forState: .Normal)
                pressed1 = false
            }
        
        
    }
    
//    var pressed4 = false
    @IBAction func onButton4Pressed(sender: AnyObject) {
        
            if !pressed1 {
                numberOfStars(4)
                pressed1 = true
                self.numberOfStars = 4
            } else {
                button1.setImage(UIImage(named:"Star" ), forState: .Normal)
                button2.setImage(UIImage(named:"Star" ), forState: .Normal)
                button3.setImage(UIImage(named:"Star" ), forState: .Normal)
                button4.setImage(UIImage(named: "Star"), forState: .Normal)
                 button5.setImage(UIImage(named: "emptyStar"), forState: .Normal)
                pressed1 = false
            }
        
    }
    
//    var pressed5 = false
    @IBAction func onButton5Pressed(sender: AnyObject) {
        
            if !pressed1 {
                numberOfStars(5)
                pressed1 = true
                self.numberOfStars = 5
            } else {
                button1.setImage(UIImage(named:"emptyStar" ), forState: .Normal)
                button2.setImage(UIImage(named:"emptyStar" ), forState: .Normal)
                button3.setImage(UIImage(named:"emptyStar" ), forState: .Normal)
                button4.setImage(UIImage(named:"emptyStar" ), forState: .Normal)
                button5.setImage(UIImage(named: "emptyStar"), forState: .Normal)
                pressed1 = false
            }
        
        
    }
    @IBAction func onSubmitButtonPressed(sender: AnyObject) {
        guard let review = textView.text else {return}
        let dict = ["review" : review, "starCount": self.numberOfStars]
        DataService.usernameRef.child(travellerID!).child("reviews").child(postID!).child(DataService.currentUserUID).setValue(dict)
        
        DataService.usernameRef.child(travellerID!).child("reviews").observeEventType(.ChildAdded, withBlock: {(snapshot2) in
            let userKey = snapshot2.key
            DataService.usernameRef.child(self.travellerID!).child("reviews").child(userKey).child("starCount").observeSingleEventOfType(.Value, withBlock: {(snapshot3) in
                
                guard let starCount = snapshot3.value as? Int else { return}
                print("this is the starcount \(starCount)")
                
               let average = self.average(starCount)
                print(" this is the average \(average)")
                DataService.usernameRef.child(self.travellerID!).updateChildValues(["trustworthy" : average])
            
                DataService.postRef.child(self.postID!).child("reviews").updateChildValues([DataService.currentUserUID: true])
            
            })
        })
        sleep(1)
        self.performSegueWithIdentifier("unwindToProfile", sender: self)
      
    }
    
    
    func average(numbers: Int...) -> Double {
        var sum = 0
        for number in numbers {
            sum += number
        }
        let  ave : Double = Double(sum) / Double(numbers.count)
        return ave
    }

    func numberOfStars(number: Int) {
        if number == 0 {
            self.button1.setImage(UIImage(named: "emptyStar"), forState: .Normal)
            self.button2.setImage(UIImage(named: "emptyStar"), forState: .Normal)
            self.button3.setImage(UIImage(named: "emptyStar"), forState: .Normal)
            self.button4.setImage(UIImage(named: "emptyStar"), forState: .Normal)
            self.button5.setImage(UIImage(named: "emptyStar"), forState: .Normal)
        }else if number == 1 {
            self.button1.setImage(UIImage(named:"Star" ), forState: .Normal)
            self.button2.setImage(UIImage(named: "emptyStar"), forState: .Normal)
            self.button3.setImage(UIImage(named: "emptyStar"), forState: .Normal)
            self.button4.setImage(UIImage(named: "emptyStar"), forState: .Normal)
            self.button5.setImage(UIImage(named: "emptyStar"), forState: .Normal)
        }else if number == 2{
            self.button1.setImage(UIImage(named:"Star" ), forState: .Normal)
            self.button2.setImage(UIImage(named: "Star"), forState: .Normal)
            self.button3.setImage(UIImage(named: "emptyStar"), forState: .Normal)
            self.button4.setImage(UIImage(named: "emptyStar"), forState: .Normal)
            self.button5.setImage(UIImage(named: "emptyStar"), forState: .Normal)
        }else if number == 3{
            self.button1.setImage(UIImage(named:"Star" ), forState: .Normal)
            self.button2.setImage(UIImage(named: "Star"), forState: .Normal)
            self.button3.setImage(UIImage(named: "Star"), forState: .Normal)
            self.button4.setImage(UIImage(named: "emptyStar"), forState: .Normal)
            self.button5.setImage(UIImage(named: "emptyStar"), forState: .Normal)
        }else if number == 4{
            self.button1.setImage(UIImage(named:"Star" ), forState: .Normal)
            self.button2.setImage(UIImage(named: "Star"), forState: .Normal)
            self.button3.setImage(UIImage(named: "Star"), forState: .Normal)
            self.button4.setImage(UIImage(named: "Star"), forState: .Normal)
            self.button5.setImage(UIImage(named: "emptyStar"), forState: .Normal)
        }else if number == 5{
            self.button1.setImage(UIImage(named:"Star" ), forState: .Normal)
            self.button2.setImage(UIImage(named: "Star"), forState: .Normal)
            self.button3.setImage(UIImage(named: "Star"), forState: .Normal)
            self.button4.setImage(UIImage(named: "Star"), forState: .Normal)
            self.button5.setImage(UIImage(named: "Star"), forState: .Normal)
            
        }
    }

    
    
    
}

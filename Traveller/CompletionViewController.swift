//
//  RatingViewController.swift
//  Traveller
//
//  Created by Tan Yee Gene on 03/10/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit
import Firebase

class CompletionController: UIViewController {
    
    
    var postID: String?
    var travellerID : String?
    @IBOutlet var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var collectionMethodLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var taskCompleteButton: UIButton!
    
    //label style
    @IBOutlet weak var PNStyle: UILabel!
    @IBOutlet weak var LStyle: UILabel!
    @IBOutlet weak var CMStyle: UILabel!
    @IBOutlet weak var PStyle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observePost(postID)
        
        PNStyle.font = UIFont(name:"Elley", size: 17)
        LStyle.font = UIFont(name: "Elley", size: 17)
        CMStyle.font = UIFont(name: "Elley", size: 17)
        PStyle.font = UIFont(name: "Elley", size: 17)
        
        taskCompleteButton.layer.backgroundColor = StyleKit.paleRed.CGColor
        taskCompleteButton.layer.cornerRadius = taskCompleteButton.frame.width / 30
        
    }
    
    
    func observePost(postID : String?){
        DataService.postRef.child(postID!).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            let post = Post(snapshot: snapshot)
            self.productNameLabel.text = post!.productName
            self.priceLabel.text = "RM " + post!.price
            self.locationLabel.text = post!.location
            self.collectionMethodLabel.text = post!.collectionMethod
            let url = NSURL(string: post!.productImage)
            self.productImage.sd_setImageWithURL(url, placeholderImage: UIImage(named:"loading"))
            
        })
        
        
        
    }
    @IBAction func onTaskCompletedButtonPressed(sender: AnyObject) {
        let completionSheet = UIAlertController(title: "Task Completed?", message: nil, preferredStyle: .ActionSheet)
        let yesAction = UIAlertAction(title: "Yes", style: .Default) { (action) in
            self.performSegueWithIdentifier("RateTravellerSegue", sender: self.travellerID)
            DataService.postRef.child(self.postID!).child("CompletionStatus").updateChildValues([self.travellerID! : true])
        }
        let noAction = UIAlertAction(title: "No", style: .Default, handler: nil)
        completionSheet.addAction(yesAction)
        completionSheet.addAction(noAction)
        self.presentViewController(completionSheet, animated: true, completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "RateTravellerSegue"{
            let destination = segue.destinationViewController as! RatingViewController
            destination.travellerID = self.travellerID
            destination.postID = self.postID
        }
    }
}
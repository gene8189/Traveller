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
    override func viewDidLoad() {
        super.viewDidLoad()
        observePost(postID)
        
    }
    
    
    func observePost(postID : String?){
        DataService.postRef.child(postID!).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            let post = Post(snapshot: snapshot)
            self.productNameLabel.text = "Product: " + post!.productName
            self.priceLabel.text = "Price: RM" + post!.price
            self.locationLabel.text = "Location: " + post!.location
            self.collectionMethodLabel.text = "Collection Method: " + post!.collectionMethod
            let url = NSURL(string: post!.productImage)
            self.productImage.sd_setImageWithURL(url, placeholderImage: UIImage(named:"loading"))
            
        })
        
        
        
    }
    @IBAction func onTaskCompletedButtonPressed(sender: AnyObject) {
        let completionSheet = UIAlertController(title: "Task Completed?", message: nil, preferredStyle: .ActionSheet)
        let yesAction = UIAlertAction(title: "Yes", style: .Default) { (action) in
            self.performSegueWithIdentifier("RateTravellerSegue", sender: self.travellerID)
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
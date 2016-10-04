//
//  DetailViewController.swift
//  Traveller
//
//  Created by Hahaboy on 27/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    enum Situation{
        case applied
        case iWantThisJob
    }
    
    
    @IBOutlet var posterUserProfileImg: UIImageView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var collectionMethodLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var applyJobButton: UIButton!
    
    var post:Post!
    var identifier:Situation?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.post.posterUID == User.currentUserUid(){
            self.applyJobButton.hidden = true
        }
        
        DataService.postRef.child(post.uid).child("travellers").observeEventType(.Value, withBlock: { snapshot in
            if snapshot.hasChild(User.currentUserUid()!){
                self.applyJobButton.setTitle("Applied", forState: .Normal)
            }else{
                self.applyJobButton.setTitle("I want this Job!", forState: .Normal)
            }
        })
        
        
        
        if let post = self.post{
            self.productNameLabel.text = "Product: " + post.productName
            self.priceLabel.text = "Price: RM" + post.price
            self.locationLabel.text = "Location: " + post.location
            self.collectionMethodLabel.text = "Collection Method: " + post.collectionMethod
            let userImageUrl = post.productImage
            let url = NSURL(string: userImageUrl)
            self.productImageView.sd_setImageWithURL(url)
            self.usernameButton.setTitle(post.posterUsername, forState: .Normal)
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            let attribute = UIFont(name: "Elley", size: 23)
            UIBarButtonItem.appearance()
                .setTitleTextAttributes([NSFontAttributeName : attribute!],
                                        forState: UIControlState.Normal)
            applyJobButton.layer.backgroundColor = StyleKit.paleRed.CGColor
            applyJobButton.layer.cornerRadius = applyJobButton.frame.width / 30
            
            
            observePosterProfilePic(self.post.posterUID)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nextScene = segue.destinationViewController as! StrangerProfileViewController
        nextScene.strangerUID = self.post.posterUID
    }
    
    @IBAction func onApplyJobButtonPressed(sender: AnyObject) {
        
        DataService.postRef.child(post.uid).child("travellers").observeEventType(.Value, withBlock: { snapshot in
            if snapshot.hasChild(User.currentUserUid()!){
                
                self.identifier = Situation.applied
            }else{
                
                self.identifier = Situation.iWantThisJob
            }
        })
        
        if let setting = identifier{
            switch setting{
            case .applied:
            DataService.postRef.child(self.post.uid).child("travellers").child(User.currentUserUid()!).removeValue()
                DataService.usernameRef.child(self.post.posterUID).child("Request").child(self.post.uid).removeValue()
                
            case .iWantThisJob:
                DataService.postRef.child(self.post.uid).child("travellers").updateChildValues([User.currentUserUid()!:true])
                DataService.usernameRef.child(self.post.posterUID).child("Request").updateChildValues([self.post.uid: true])
            }
        }
        
        
        
    }
    func observePosterProfilePic (userUId: String) {
        DataService.usernameRef.child(userUId).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            if let posterUserProfile = Username(snapshot: snapshot) {
                let url = NSURL(string: posterUserProfile.profileImage)
                self.posterUserProfileImg.sd_setImageWithURL(url, placeholderImage: UIImage(named: "profile16"))
                self.posterUserProfileImg.layer.cornerRadius = self.posterUserProfileImg.frame.width / 2
                self.posterUserProfileImg.clipsToBounds = true
                
            }
        })
    }
    
}

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
    
    
    @IBOutlet weak var ratingButton: UIButton!
    @IBOutlet var posterUserProfileImg: UIImageView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var collectionMethodLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var applyJobButton: UIButton!
    
    //label Style
    
    @IBOutlet weak var PNStyle: UILabel!
    @IBOutlet weak var LStyle: UILabel!
    @IBOutlet weak var CMStyle: UILabel!
    @IBOutlet weak var PStyle: UILabel!
    
    var post:Post!
    var identifier:Situation?
    var choosen:Bool = false
    var rejected:Bool = false
    var productID:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ratingButton.hidden = true
        PNStyle.font = UIFont(name:"Elley", size: 17)
        LStyle.font = UIFont(name: "Elley", size: 17)
        CMStyle.font = UIFont(name: "Elley", size: 17)
        PStyle.font = UIFont(name: "Elley", size: 17)
        
        ratingButton.layer.backgroundColor = StyleKit.paleRed.CGColor
        ratingButton.layer.cornerRadius = ratingButton.frame.width / 30
        
        
        if productID != nil{
            if let productID = self.productID{
                DataService.postRef.child(productID).observeEventType(.Value, withBlock: { snapshot in
                    if let post = Post(snapshot: snapshot){
                        DataService.usernameRef.child(post.posterUID).observeEventType(.Value, withBlock: { userSnapshot in
                            if let user = User(snapshot: userSnapshot){
                                post.posterUsername = user.username
                                self.post = post
                                self.setupPost()
                            }
                        })
                    }
                })
            }
        }
        
        if self.post != nil {
            self.setupPost()
        }

        
    }
    
    func setupPost(){
        if self.post.posterUID == User.currentUserUid(){
            self.applyJobButton.hidden = true
        }
        
        //check whether this job completed
        DataService.postRef.child(self.post.uid).child("CompletionStatus").observeEventType(.Value, withBlock: { snapshot in
                if snapshot.hasChildren(){
                    let keyArray = snapshot.value?.allKeys as! [String]
                    let keyArray2 = snapshot.value?.allValues as! [Int]
                    
                    for (index,i) in keyArray2.enumerate(){
                        if i == 1{
                            if keyArray[index] == User.currentUserUid(){
                                self.ratingButton.hidden = false
                            }
                        }
                    }
                    
                }
            })
        
        
        DataService.postRef.child(self.post.uid).child("RequestStatus").observeEventType(.Value, withBlock: { snapshot in
            if snapshot.hasChildren(){
                let keyArray = snapshot.value?.allKeys as! [String]
                let keyArray2 = snapshot.value?.allValues as! [Int]
                
                if keyArray2.contains(1){
                    for (index,key) in keyArray2.enumerate() {
                        if key == 0{
                            if keyArray[index] == User.currentUserUid(){
    
                                self.rejected = true
                            }
                        }
                    }
                }
            }
        })
        
        DataService.postRef.child(self.post.uid).child("RequestStatus").observeEventType(.Value, withBlock: { snapshot in
            if snapshot.hasChildren(){
                let keyArray = snapshot.value?.allKeys as! [String]
                let keyArray2 = snapshot.value?.allValues as! [Int]
                for (index,key) in keyArray2.enumerate() {
                    if key == 1{
                        if keyArray[index] == User.currentUserUid(){
                            
                            self.choosen = true
                        }
                    }
                }
            }
        })
        
        DataService.postRef.child(post.uid).child("travellers").observeEventType(.Value, withBlock: { snapshot in
            if self.choosen{
                self.applyJobButton.setTitle("You have been Choosen", forState: .Normal)
                self.applyJobButton.userInteractionEnabled = false
            }else if self.rejected{
                self.applyJobButton.setTitle("Somebody took the job", forState: .Normal)
                self.applyJobButton.userInteractionEnabled = false
            }else if snapshot.hasChild(User.currentUserUid()!){
                self.applyJobButton.setTitle("Applied", forState: .Normal)
            }else{
                self.applyJobButton.setTitle("I want this Job!", forState: .Normal)
            }
        })
        
        
        
        if let post = self.post{
            self.productNameLabel.text = post.productName
            self.priceLabel.text = "RM " + post.price
            self.locationLabel.text = post.location
            self.collectionMethodLabel.text = post.collectionMethod
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
        if segue.identifier == "StrangerSegue"{
            let nextScene = segue.destinationViewController as! StrangerProfileViewController
            nextScene.strangerUID = self.post.posterUID
        }else if segue.identifier == "RatingSegue"{
            let nextScene = segue.destinationViewController as! RatingViewController
            nextScene.travellerID = self.post.posterUID
            nextScene.postID = self.post.uid
        }
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
                DataService.postRef.child(self.post.uid).child("RequestStatus").child(User.currentUserUid()!).removeValue()
                
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

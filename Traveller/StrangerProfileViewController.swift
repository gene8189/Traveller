//
//  StrangerProfileViewController.swift
//  Traveller
//
//  Created by Hahaboy on 27/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit

class StrangerProfileViewController: UIViewController {

    enum Situation{
        case friend
        case pending
        case confirm
        case addfriend
    }
    
    @IBOutlet weak var messageMeButton: UIButton!
    @IBOutlet weak var addFriendButton: UIButton!
    @IBOutlet weak var aboutMeLabel: UITextView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var checker:Bool = true
    var identifier:Situation?
    var strangerUID:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView!.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView!.clipsToBounds = true
        
        if strangerUID == User.currentUserUid(){
            self.addFriendButton.hidden = true
            self.messageMeButton.hidden = true
        }
        
        DataService.usernameRef.child(User.currentUserUid()!).child("friends").observeEventType(.Value, withBlock: { friendSnapshot in
                DataService.usernameRef.child(User.currentUserUid()!).child("pending-friends").observeEventType(.Value, withBlock: { confirmFriendSnapshot in
                    DataService.usernameRef.child(self.strangerUID).child("pending-friends").observeEventType(.Value, withBlock: { pendingFriendSnapshot in
                        if friendSnapshot.hasChild(self.strangerUID){
                            self.addFriendButton.setTitle("Friend", forState: .Normal)
                        }else if confirmFriendSnapshot.hasChild(self.strangerUID){
                            self.addFriendButton.setTitle("Confirm Friend", forState: .Normal)
                        }else if pendingFriendSnapshot.hasChild(User.currentUserUid()!){
                            self.addFriendButton.setTitle("Pending", forState: .Normal)
                        }else{
                            self.addFriendButton.setTitle("Add as Friend", forState: .Normal)
                        }
                    })
                })
            })
        
        DataService.usernameRef.child(self.strangerUID).observeEventType(.Value, withBlock: { userSnapshot in
            if let user = User(snapshot: userSnapshot){
                
                if user.profileImage == ""{
                    self.profileImageView.image = UIImage(named: "defaultProfile")
                }else{
                    let url = NSURL(string: user.profileImage)
                    self.profileImageView.sd_setImageWithURL(url)
                }
                
                self.aboutMeLabel.text = user.description
                self.usernameLabel.text = user.username
                
            }
        })
        
    }

    @IBAction func onMessageButtonPressed(sender: AnyObject) {
        
    }
    
    @IBAction func onAddFriendButtonPressed(sender: AnyObject) {
        
        DataService.usernameRef.child(User.currentUserUid()!).child("friends").observeEventType(.Value, withBlock: { friendSnapshot in
            DataService.usernameRef.child(User.currentUserUid()!).child("pending-friends").observeEventType(.Value, withBlock: { confirmFriendSnapshot in
                DataService.usernameRef.child(self.strangerUID).child("pending-friends").observeEventType(.Value, withBlock: { pendingFriendSnapshot in
                    if friendSnapshot.hasChild(self.strangerUID){
//                        self.addFriendButton.setTitle("Friend", forState: .Normal)
                        //alert controller
                        
                         self.identifier = Situation.friend
                        
                        
                        
                        
                        
                        
                    }else if confirmFriendSnapshot.hasChild(self.strangerUID){
//                        self.addFriendButton.setTitle("Confirm Friend", forState: .Normal)
                        //alert controller
                        
                         self.identifier = Situation.confirm
                        
                        
                        
                        
                    }else if pendingFriendSnapshot.hasChild(User.currentUserUid()!){
//                        self.addFriendButton.setTitle("Pending", forState: .Normal)
                        
                         self.identifier = Situation.pending
                        
                        
                        
                    }else{
                        //both party are not friend
                         self.identifier = Situation.addfriend
                        
                    }
                })
            })
        })
        
        
        if let setting = identifier{
            switch setting{
            case .friend:
                
                let alertController = UIAlertController(title: "Unfriend", message: "Are you sure want to unfriend?", preferredStyle: UIAlertControllerStyle.Alert)
                
                let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                    
                    DataService.usernameRef.child(self.strangerUID).child("friends").child(User.currentUserUid()!).removeValue()
                    DataService.usernameRef.child(User.currentUserUid()!).child("friends").child(self.strangerUID).removeValue()
                    
                }
                let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel) {
                    UIAlertAction in
                    
                }
                alertController.addAction(yesAction)
                alertController.addAction(noAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
            case .confirm:
                
                let alertController = UIAlertController(title: "Confirm Friend", message: "Are you sure want to add friend?", preferredStyle: UIAlertControllerStyle.Alert)
                
                let acceptAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                    
                    DataService.usernameRef.child(User.currentUserUid()!).child("pending-friends").child(self.strangerUID).removeValue()
                    DataService.usernameRef.child(User.currentUserUid()!).child("friends").updateChildValues([self.strangerUID:true])
                    DataService.usernameRef.child(self.strangerUID).child("friends").updateChildValues([User.currentUserUid()!:true])
                    
                    
                }
                let declineAction = UIAlertAction(title: "Decline", style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                    
                    DataService.usernameRef.child(User.currentUserUid()!).child("pending-friends").child(self.strangerUID).removeValue()
                    
                }
                let cancelAction = UIAlertAction(title: "Back", style: UIAlertActionStyle.Cancel) {
                    UIAlertAction in
                    
                }
                alertController.addAction(acceptAction)
                alertController.addAction(declineAction)
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
            case .pending:
                
                DataService.usernameRef.child(self.strangerUID).child("pending-friends").child(User.currentUserUid()!).removeValue()
                
            case .addfriend:
                
                DataService.usernameRef.child(self.strangerUID).child("pending-friends").updateChildValues([User.currentUserUid()!:true])
                
            }
        }
        
        
        
//            if checker {
//                DataService.usernameRef.child(self.strangerUID).child("pending-friends").updateChildValues([User.currentUserUid()!:true])
//                checker = false
//            }else{
//                DataService.usernameRef.child(self.strangerUID).child("pending-friends").child(User.currentUserUid()!).removeValue()
//                checker = true
//            }
        
    }
}

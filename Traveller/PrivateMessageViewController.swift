//
//  PrivateMessageViewController.swift
//  Traveller
//
//  Created by Tan Yee Gene on 27/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import FirebaseAuth
import FirebaseDatabase

class PrivateMessageViewController: JSQMessagesViewController {
    var messages = [JSQMessage]()
    var activityIndicator: UIActivityIndicatorView?
//    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        DataService.usernameRef.child(uid).child("username").observeSingleEventOfType(.Value , withBlock: {(snapshot) in
            let senderDisplayName = snapshot.value as? String
            print("this is sender displayname : \(senderDisplayName)")
            print("this is the uid :\(uid)")
            
            self.senderId = uid
            self.senderDisplayName = senderDisplayName!
            
            
        })
        self.senderId = "placeholder"
        self.senderDisplayName = "placeholder"
    }
    
    override func viewDidAppear(animated: Bool) {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 50, height: 50)))
        
        activityIndicator?.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator?.color = UIColor.blackColor()
        
        self.view.addSubview(activityIndicator!)
        self.view.bringSubviewToFront(activityIndicator!)
        activityIndicator?.center = view.center
        activityIndicator!.startAnimating()
    }

    @IBAction func onHomeButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}

//
//  StrangerProfileViewController.swift
//  Traveller
//
//  Created by Hahaboy on 27/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit

class StrangerProfileViewController: UIViewController {

    @IBOutlet weak var addFriendButton: UIButton!
    @IBOutlet weak var aboutMeLabel: UITextView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    var strangerUID:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
    }
}

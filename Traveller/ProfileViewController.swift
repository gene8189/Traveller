//
//  ProfileViewController.swift
//  Traveller
//
//  Created by Hahaboy on 26/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    @IBOutlet weak var aboutMeLabel: UITextView!
    @IBOutlet weak var trustworthyLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    var user:User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        DataService.usernameRef.child(User.currentUserUid()!).observeEventType(.Value, withBlock: { userSnapshot in
            if let user = User(snapshot: userSnapshot){
                
                if user.profileImage == ""{
                    self.profileImageView.image = UIImage(named: "defaultProfile")
                }else{
                    let url = NSURL(string: user.profileImage)
                    self.profileImageView.sd_setImageWithURL(url)
                }
                
                self.aboutMeLabel.text = user.description
                self.usernameLabel.text = user.username
                self.user = user
                
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nextScene = segue.destinationViewController as! EditProfileViewController
        nextScene.user = self.user
    }
    
    @IBAction func unwindToProfile(segue: UIStoryboardSegue) {
    }
}

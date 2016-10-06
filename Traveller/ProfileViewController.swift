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
    @IBOutlet var profileRating: UIImageView!
    
    
    
    var user:User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView!.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView!.clipsToBounds = true
        
        DataService.usernameRef.child(User.currentUserUid()!).observeEventType(.Value, withBlock: { userSnapshot in
            if let user = User(snapshot: userSnapshot){
                
                if user.profileImage == ""{
                    self.profileImageView.image = UIImage(named: "defaultProfile")
                }else{
                    let url = NSURL(string: user.profileImage!)
                    self.profileImageView.sd_setImageWithURL(url)
                }
                
                self.aboutMeLabel.text = user.description
                self.usernameLabel.attributedText = self.BoldString(user.username!)
                self.user = user
                
                if user.rating == 0 {
                    self.profileRating.image = UIImage(named: "empty")
                } else if user.rating == 1{
                    self.profileRating.image = UIImage(named: "1")
                } else if user.rating == 2 {
                    self.profileRating.image = UIImage(named: "2")
                }else if user.rating == 3 {
                    self.profileRating.image = UIImage(named: "3")
                }else if user.rating == 4 {
                    self.profileRating.image = UIImage(named: "4")
                }else if user.rating == 5 {
                    self.profileRating.image = UIImage(named: "5")
                }

                
            }
        })
        
        // Title Decoration
        self.navigationController?.navigationBarHidden =  false
        self.title = "Profile"
        let attributes: AnyObject = [ NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = attributes as? [String : AnyObject]
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Elley", size: 23.0)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        navigationController?.navigationBar.barTintColor = StyleKit.darkRed
    }
    
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditSegue"{
            let nextScene = segue.destinationViewController as! EditProfileViewController
            nextScene.user = self.user
        }
    }
    
    @IBAction func unwindToProfile(segue: UIStoryboardSegue) {
    }
}

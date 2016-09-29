//
//  SignUpControllerViewController.swift
//  Traveller
//
//  Created by Tan Yee Gene on 26/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import Firebase

class SignInControllerViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var emailLoginButton: UIButton!
    @IBOutlet var fbLoginButton: FBSDKLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fbLoginButton.delegate = self
        self.emailLoginButton.backgroundColor = StyleKit.green
        emailLoginButton.layer.cornerRadius = emailLoginButton.bounds.width / 60
        fbLoginButton.layer.cornerRadius = fbLoginButton.bounds.width / 25
        activityIndicator.hidden = true
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if let error = error {
            print(error.localizedDescription)
            print("outside")
            let alert = UIAlertController(title: "Sign up Failed", message: error.localizedDescription, preferredStyle: .Alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
            
            alert.addAction(dismissAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            if let user = user {
                NSUserDefaults.standardUserDefaults().setObject(user.uid, forKey: "userUID")
                self.performSegueWithIdentifier("HomeSegue", sender: nil)
                
                let firebaseRef = FIRDatabase.database().reference()
                let currentUserRef = firebaseRef.child("Usernames").child(user.uid)
                let userDict = ["username": user.displayName!]
                currentUserRef.updateChildValues(userDict)
                
            }
        }
        
    }
    
    @IBAction func onSignInWithEmailButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        try! FIRAuth.auth()!.signOut()
    }
    
    override func prefersStatusBarHidden() -> Bool{
        return true
    }
    

}

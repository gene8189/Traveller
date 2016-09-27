//
//  SignUpViewController.swift
//  Traveller
//
//  Created by Tan Yee Gene on 26/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    @IBOutlet var tapAction: UITapGestureRecognizer!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var backToFacebookLogin: UIButton!
    @IBOutlet var forgotPasswordButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    var activeTextField : UITextField?
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.backgroundColor = StyleKit.yellow
        registerButton.layer.borderWidth = 0.3
        registerButton.layer.cornerRadius = registerButton.bounds.width / 25
        backToFacebookLogin.layer.borderWidth = 0.5
        backToFacebookLogin.layer.borderColor = UIColor(white: 1, alpha: 0.5).CGColor
        backToFacebookLogin.layer.backgroundColor = UIColor(white: 1, alpha: 0.3).CGColor
        loginButton.backgroundColor = StyleKit.green
        loginButton.layer.borderWidth = 0.3
        loginButton.layer.cornerRadius = loginButton.bounds.width / 25
        loginButton.hidden = true
        forgotPasswordButton.hidden = true
        loginButton.enabled = false
        forgotPasswordButton.enabled = false
        registerButton.hidden = false
        registerButton.enabled = true
        activityIndicator.hidden = true
    }
    
    @IBAction func indexChanged(sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            registerButton.hidden = false
            registerButton.enabled = true
            usernameTextField.hidden = false
            usernameTextField.enabled = true
            loginButton.hidden = true
            forgotPasswordButton.hidden = true
            loginButton.enabled = false
            forgotPasswordButton.enabled = false
            activityIndicator.hidden = true
            emailTextField.text = ""
            passwordTextField.text = ""
            usernameTextField.text = ""
            
        case 1:
            usernameTextField.hidden = true
            registerButton.hidden = true
            usernameTextField.enabled = false
            registerButton.enabled = false
            loginButton.hidden = false
            forgotPasswordButton.hidden = false
            loginButton.enabled = true
            forgotPasswordButton.enabled = true
            activityIndicator.hidden = true
            emailTextField.text = ""
            passwordTextField.text = ""
            usernameTextField.text = ""
            
            
        default:
            break;
        }
        
    }
    
    
    @IBAction func onLoginButtonPressed(sender: AnyObject) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
            else {return}
        
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion:  { (user, error) in
            if error != nil {
                print(error?.localizedDescription)
                let alert = UIAlertController(title: "Sign In Failed", message: error?.localizedDescription, preferredStyle: .Alert)
                let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
                alert.addAction(dismissAction)
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.presentViewController(alert, animated: true, completion: nil)
                
                return
                
            }else {
                FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
                    self.activityIndicator.hidden = false
                    self.activityIndicator.startAnimating()
                    if let user = user{
                        let uid = user.uid
                        NSUserDefaults.standardUserDefaults().setObject(uid, forKey: "userUID")
                        
                        let storyBoard = UIStoryboard(name:"TabBarStoryboard", bundle:NSBundle.mainBundle())
                        
                        let tabBarController = storyBoard.instantiateViewControllerWithIdentifier("TabBarController")
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        appDelegate.window?.rootViewController=tabBarController
                          self.performSegueWithIdentifier("HomeSegue", sender: nil)
                    }
                }
            }
        })
        
      
     
    }
    
    
    @IBAction func onRegisterButtonPressed(sender: AnyObject) {
        guard
            let username = usernameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text else {
                return
        }
        FIRAuth.auth()?.createUserWithEmail(email, password: password) { (user, error) in
            if error != nil {
                print(error?.localizedDescription)
                let alert = UIAlertController(title: "Sign Up Failed", message: error?.localizedDescription, preferredStyle: .Alert)
                let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
                alert.addAction(dismissAction)
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.usernameTextField.text = ""
                self.presentViewController(alert, animated: true, completion: nil)
                
                return
            }
            if let user = user {
                self.activityIndicator.hidden = false
                self.activityIndicator.startAnimating()
                let uid = user.uid
                NSUserDefaults.standardUserDefaults().setObject(uid, forKey: "userUID")
                
                let firebaseRef = FIRDatabase.database().reference()
                let username = ["username" : username, "profileImage": "", "self-description": "", "trustworthy" : ""]
                firebaseRef.child("Usernames").child(uid).setValue(username)
                let storyBoard = UIStoryboard(name:"TabBarStoryboard", bundle:NSBundle.mainBundle())
                
                let tabBarController = storyBoard.instantiateViewControllerWithIdentifier("TabBarController")
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.window?.rootViewController=tabBarController
                 self.performSegueWithIdentifier("HomeSegue", sender: nil)
                
            }
        }
        
       
    }
    
    @IBAction func tapAction(sender: UITapGestureRecognizer) {
        self.passwordTextField.resignFirstResponder()
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        self.usernameTextField.resignFirstResponder()
    }

    @IBAction func onBackToFacebookButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("FacebookSegue", sender: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool{
        return true
    }
}

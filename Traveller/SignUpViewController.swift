//
//  SignUpViewController.swift
//  Traveller
//
//  Created by Tan Yee Gene on 26/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import Firebase

class SignUpViewController: UIViewController, FBSDKLoginButtonDelegate {
    @IBOutlet var tapAction: UITapGestureRecognizer!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var forgotPasswordButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var fbLoginButton: FBSDKLoginButton!
    var activeTextField : UITextField?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var attributes = NSDictionary(object: UIFont(name: "HelveticaNeue", size: 18.0)!, forKey: NSFontAttributeName)
        segmentedControl.setTitleTextAttributes(attributes as [NSObject : AnyObject], forState: .Normal)
        
        //gradient
        let gradientColors = [StyleKit.darkRed.CGColor, StyleKit.lighterRed.CGColor]
        let gradientLocation = [ 0.1 , 0.5]
        let gradientLayer : CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocation
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
        
        
        //email
        emailTextField.backgroundColor = UIColor(white: 1, alpha: 0.5)
        emailTextField.layer.cornerRadius = emailTextField.frame.width / 30
        emailTextField.leftViewMode = UITextFieldViewMode.Always
        emailTextField.leftView = makeImageView("Mail")
        
        //password
        passwordTextField.backgroundColor = UIColor(white: 1, alpha: 0.5)
        passwordTextField.layer.cornerRadius = passwordTextField.frame.width / 30
        passwordTextField.leftViewMode = UITextFieldViewMode.Always
        passwordTextField.leftView = makeImageView("lock")
        
        //username
        usernameTextField.backgroundColor = UIColor(white: 1, alpha: 0.5)
        usernameTextField.layer.cornerRadius = usernameTextField.frame.width / 30
        usernameTextField.leftViewMode = UITextFieldViewMode.Always
        usernameTextField.leftView = makeImageView("profile16")
        
        
        
        registerButton.layer.backgroundColor = StyleKit.paleRed.CGColor
        registerButton.layer.cornerRadius = registerButton.bounds.width / 30
        loginButton.layer.backgroundColor = StyleKit.paleRed.CGColor
        loginButton.layer.cornerRadius = loginButton.bounds.width / 30
        
        self.fbLoginButton.delegate = self
        fbLoginButton.layer.cornerRadius = fbLoginButton.bounds.width / 200
        fbLoginButton.backgroundColor = StyleKit.lighterRed
        
        
        
        loginButton.hidden = true
        forgotPasswordButton.hidden = true
        loginButton.enabled = false
        forgotPasswordButton.enabled = false
        registerButton.hidden = false
        registerButton.enabled = true
        activityIndicator.hidden = true
    }
    
    
    func makeImageView(imageName: String) -> UIView{
        let ImgContainer = UIView(frame: CGRectMake(emailTextField.frame.origin.x, emailTextField.frame.origin.y, 40.0, 30.0))
        let ImageView = UIImageView(frame: CGRectMake(0 , 0 , 25.0 , 25.0))
        ImageView.image = UIImage(named: imageName)
        ImageView.center = CGPointMake(ImgContainer.frame.size.width / 2, ImgContainer.frame.size.height / 2)
        ImgContainer.addSubview(ImageView)
        return ImgContainer
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
                let username = ["username" : username]
                firebaseRef.child("Usernames").child(uid).setValue(username)
                let storyBoard = UIStoryboard(name:"TabBarStoryboard", bundle:NSBundle.mainBundle())
                
                let tabBarController = storyBoard.instantiateViewControllerWithIdentifier("TabBarController")
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.window?.rootViewController=tabBarController
                self.performSegueWithIdentifier("HomeSegue", sender: nil)
                
            }
        }
        
        
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
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        try! FIRAuth.auth()!.signOut()
    }
    
    @IBAction func tapAction(sender: UITapGestureRecognizer) {
        self.passwordTextField.resignFirstResponder()
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        self.usernameTextField.resignFirstResponder()
    }
    
    override func prefersStatusBarHidden() -> Bool{
        return true
    }
}

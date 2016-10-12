//
//  EditProfileViewController.swift
//  Traveller
//
//  Created by Hahaboy on 26/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit
import FirebaseStorage

class EditProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var starCount: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var aboutMeTextView: UITextView!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var selectedImage:UIImage!
    var user:User!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.aboutMeTextView.text = self.user.description
        self.usernameTextField.text = self.user.username
        
        self.hideKeyboardWhenTappedAround()
        
        self.title = "Edit Profile"
        let attributes: AnyObject = [ NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = attributes as? [String : AnyObject]
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Elley", size: 23.0)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.saveButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Elley", size: 23.0)!], forState: UIControlState.Normal)
        self.saveButton.tintColor = UIColor.grayColor()
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let attribute = UIFont(name: "Elley", size: 23.0)
        UIBarButtonItem.appearance()
            .setTitleTextAttributes([NSFontAttributeName : attribute!],
                                    forState: UIControlState.Normal)
        
        

        
        if user.profileImage == ""{
            self.profileImageView.image = UIImage(named: "defaultProfile")
        }else{
            let url = NSURL(string: user.profileImage!)
            self.profileImageView.sd_setImageWithURL(url)
        }
        
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectProfileImage)))
        profileImageView.userInteractionEnabled = true
        
        
        
        if user.rating == 0 {
           starCount.image = UIImage(named: "empty")
        } else if user.rating == 1{
            starCount.image = UIImage(named: "1")
        } else if user.rating == 2 {
            starCount.image = UIImage(named: "2")
        }else if user.rating == 3 {
            starCount.image = UIImage(named: "3")
        }else if user.rating == 4 {
            starCount.image = UIImage(named: "4")
        }else if user.rating == 5 {
            starCount.image = UIImage(named: "5")
        }

        
    }

    @IBAction func onSaveButtonPressed(sender: AnyObject) {
        let username = self.usernameTextField.text
        
        let description = self.aboutMeTextView.text
        
        DataService.usernameRef.child(User.currentUserUid()!).child("username").setValue(username)
        DataService.usernameRef.child(User.currentUserUid()!).child("self-description").setValue(description)
        
        if let profileImage = self.selectedImage{
            
            let uniqueImageName = NSUUID().UUIDString
            let storageRef = FIRStorage.storage().reference().child("\(uniqueImageName).png")
            if let imageToUpload = UIImageJPEGRepresentation(profileImage, 0.5) {
                
                storageRef.putData(imageToUpload, metadata: nil, completion: { (metadata, error) in
                    if error != nil{
                        print(error)
                        return
                    }
                    let userRef = DataService.usernameRef.child(User.currentUserUid()!)
                    if let imageURL = metadata?.downloadURL()?.absoluteString{
                        userRef.child("profileImage").setValue(imageURL)
                    }
                })
            }
        }
        performSegueWithIdentifier("unwindToProfile", sender: self)
    }
    
    func selectProfileImage () {
        let picker = UIImagePickerController ()
        picker.delegate = self
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        var selectedImageFromPicker : UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            self.profileImageView.image = selectedImage
            self.selectedImage = selectedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

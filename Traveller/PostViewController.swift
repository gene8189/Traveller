//
//  PostViewController.swift
//  Traveller
//
//  Created by Hahaboy on 26/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit
import Fusuma
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SDWebImage

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func BoldString(text:String,size:CGFloat) -> NSMutableAttributedString{
        
        let att = [NSFontAttributeName : UIFont.boldSystemFontOfSize(size)]
        
        let boldText = NSMutableAttributedString(string:text, attributes:att)
        
        return boldText
    }
}

class PostViewController: UIViewController,FusumaDelegate,UITextFieldDelegate {
    
    
    @IBOutlet var postButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    var activeTextField:UITextField?
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var collectionTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var selectImageView: UIImageView!
    
    //label style
    @IBOutlet weak var PNStyle: UILabel!
    @IBOutlet weak var LStyle: UILabel!
    @IBOutlet weak var CMStyle: UILabel!
    @IBOutlet weak var PStyle: UILabel!
    
    var selectedImage = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PNStyle.font = UIFont(name:"Elley", size: 17)
        LStyle.font = UIFont(name: "Elley", size: 17)
        CMStyle.font = UIFont(name: "Elley", size: 17)
        PStyle.font = UIFont(name: "Elley", size: 17)
        
        self.hideKeyboardWhenTappedAround()
        self.productNameTextField.text = ""
        self.locationTextField.text = ""
        self.collectionTextField.text = ""
        self.priceTextField.text = ""
        self.selectImageView.image = UIImage(named: "camera")
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        selectImageView.userInteractionEnabled = true
        selectImageView.addGestureRecognizer(tapGestureRecognizer)
        
        
        // Title Decoration
        self.navigationController?.navigationBarHidden =  false
        self.title = "Post"
        let attributes: AnyObject = [ NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = attributes as? [String : AnyObject]
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Elley", size: 23.0)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.barTintColor = StyleKit.darkRed
        
        postButton.layer.backgroundColor = StyleKit.paleRed.CGColor
        postButton.layer.cornerRadius = postButton.frame.width / 30
        
    }
    
    func imageTapped(){
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.hasVideo = true // If you want to let the users allow to use video.
        self.presentViewController(fusuma, animated: true, completion: nil)
    }
    
    
    func fusumaImageSelected(image: UIImage) {
        
        print("Image selected")
        
        self.selectImageView.image = image
        
        self.selectedImage = image
        
    }
    
    //save image into database
    @IBAction func onPostButtonPressed(sender: AnyObject) {
        
        let uniqueImageName = NSUUID().UUIDString
        let storageRef = FIRStorage.storage().reference().child("\(uniqueImageName).png")
        
        guard
            let selectedImage = UIImageJPEGRepresentation(self.selectedImage, 0.5) else {return}
        
        
        storageRef.putData(selectedImage, metadata: nil, completion: { (metadata, error) in
            if error != nil{
                print(error)
                return
            }
            
            
            let currentUserRef = DataService.postRef.childByAutoId()
            if let imageURL = metadata?.downloadURL()?.absoluteString, user = User.currentUserUid(), productName = self.productNameTextField.text, location = self.locationTextField.text, collectionMethod = self.collectionTextField.text, price = self.priceTextField.text {
                
                let value = ["imgurl":imageURL, "posterUID":user, "created_at":NSDate().timeIntervalSince1970, "productName":productName, "location":location, "collectionMethod":collectionMethod, "price":price ]
                currentUserRef.setValue(value)
                
                
                FIRDatabase.database().reference().child("Usernames").child(User.currentUserUid()!).child("post").updateChildValues([currentUserRef.key: true])
                
                SDImageCache.sharedImageCache().storeImage(self.selectedImage, forKey: imageURL)
                
                
                self.productNameTextField.text = ""
                self.locationTextField.text = ""
                self.collectionTextField.text = ""
                self.priceTextField.text = ""
                self.selectImageView.image = UIImage(named: "takePhoto")
                self.priceTextField.resignFirstResponder()
                self.productNameTextField.resignFirstResponder()
                self.locationTextField.resignFirstResponder()
                self.collectionTextField.resignFirstResponder()
            }
            
            
        })
        
        performSegueWithIdentifier("unwindToHomeTabBar", sender: self)
        
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(image: UIImage) {
        
        print("Called just after FusumaViewController is dismissed.")
        
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: NSURL) {
        
        print("Called just after a video has been selected.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
    }
    
    func fusumaClosed() {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}

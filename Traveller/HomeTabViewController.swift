//
//  HomeTabViewController.swift
//  Traveller
//
//  Created by Tan Yee Gene on 26/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseDatabase
import FirebaseAuth

class HomeTabViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var logoutButton: UIBarButtonItem!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    var listOfPosts = [Post]()
    var post:Post!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        // Title Decoration
        self.navigationController?.navigationBarHidden =  false
        self.title = "Home"
        let attributes: AnyObject = [ NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = attributes as? [String : AnyObject]
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Elley", size: 23.0)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        
        // navigationBar decoration
        navigationController?.navigationBar.barTintColor = StyleKit.darkRed
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.whiteColor()
        
        let attribute = UIFont(name: "Elley", size: 23.0)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSFontAttributeName : attribute!], forState: .Normal)
        
        
        
        
        DataService.postRef.observeEventType(.ChildAdded, withBlock: { postSnapshot in
            if let post = Post(snapshot: postSnapshot){
                
                
                DataService.usernameRef.child(post.posterUID).observeSingleEventOfType(.Value, withBlock: { userSnapshot in
                    if let user = User(snapshot: userSnapshot){
                        post.posterUsername = user.username
                        self.listOfPosts.append(post)
                        self.listOfPosts.sortInPlace { $0.date > $1.date }
                        self.collectionView.reloadData()
                        self.activityIndicator.hidden = true
                    }
                })
            }
        })
        if listOfPosts.count == 0 {
            activityIndicator.stopAnimating()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        activityIndicator.startAnimating()
    }
    
    @IBAction func onLogoutButtonPressed(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userUID")
        let manager = FBSDKLoginManager()
        manager.logOut()
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let viewController = storyboard.instantiateViewControllerWithIdentifier("SignUpViewController")
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    @IBAction func unwindToHomeTabBar(segue: UIStoryboardSegue) {
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenWidth = self.view.frame.size.width - 10
        let itemWidth = screenWidth / 2
        return CGSizeMake(itemWidth, itemWidth)
    }
    
    //spacing between each row
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listOfPosts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ProductCell
        let post = self.listOfPosts[indexPath.row]
        
        cell.layer.cornerRadius = cell.frame.width / 30
        
        cell.backgroundColor = StyleKit.skinColor
//        cell.productNameLabel.backgroundColor = StyleKit.skinColor
        cell.productNameLabel.attributedText = self.BoldString(post.productName,size: 15)
        let tempString = "RM " + post.price
        cell.priceLabel.attributedText = self.BoldString(tempString,size: 11)
        
        cell.layer.shadowColor = UIColor.blackColor().CGColor
        cell.layer.shadowOffset = CGSizeMake(0, 1)
        cell.layer.shadowOpacity = 1
        cell.layer.shadowRadius = 1.0
        cell.clipsToBounds = false
        cell.layer.masksToBounds = false

        
        
        let userImageUrl = post.productImage
        let url = NSURL(string: userImageUrl)
        cell.productImageView.sd_setImageWithURL(url)
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let post = self.listOfPosts[indexPath.row]
        self.post = post
        self.performSegueWithIdentifier("DetailSegue", sender: self)
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nextScene = segue.destinationViewController as! DetailViewController
        nextScene.post = self.post
    }
    
   

    
}

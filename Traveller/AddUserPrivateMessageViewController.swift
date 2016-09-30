//
//  AddUserPrivateMessageViewController.swift
//  Traveller
//
//  Created by Tan Yee Gene on 27/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class AddUserPrivateMessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var listOfUser = [Username]()
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserProfile()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        activityIndicator.startAnimating()
        
        if self.listOfUser.count < 0 {
            activityIndicator.stopAnimating()
        }
         navigationController?.navigationBar.barTintColor = StyleKit.darkRed
        navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        
        
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfUser.count

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! AddUserPrivateMessageTableViewCell
        let dict = self.listOfUser[indexPath.row]
        let url = NSURL(string: dict.profileImage)
        
        cell.usernameLabel.text = dict.username
        cell.userProfileImage.sd_setImageWithURL(url, placeholderImage: UIImage(named: "loading"))
        cell.userProfileImage.layer.cornerRadius = cell.userProfileImage.bounds.width / 2
        cell.userProfileImage.clipsToBounds = true
        return cell
    }
    
    func loadUserProfile(){
        let uid = FIRAuth.auth()!.currentUser!.uid
        DataService.usernameRef.child(uid).child("friends").observeEventType(.ChildAdded, withBlock: {(snapshot) in
            let userKey = snapshot.key
            
            DataService.usernameRef.child(userKey).observeSingleEventOfType(.Value, withBlock: {(snapshot2) in
                if let userProfile = Username(snapshot: snapshot2) {
                    self.listOfUser.append(userProfile)
                    self.tableView.reloadData()
                    self.activityIndicator.hidden = true
                }
            })
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as! UINavigationController
        let controller = destination.viewControllers.first as! PrivateMessageViewController
        let index = self.tableView.indexPathForSelectedRow
        let user = self.listOfUser[(index?.row)!]
        controller.userUID = user.userUID
    }
    
}

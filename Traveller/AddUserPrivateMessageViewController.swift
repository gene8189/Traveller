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

class AddUserPrivateMessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    var listOfUser = [Username]()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    var searchBarText = String?()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserProfile()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        tableView.separatorColor = StyleKit.darkRed
        activityIndicator.startAnimating()
        UISearchBar.appearance().tintColor = UIColor.whiteColor()
        
        if self.listOfUser.count < 0 {
            activityIndicator.stopAnimating()
        }
        self.title = "Find Friend"
        navigationController?.navigationBar.barTintColor = StyleKit.darkRed
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let attribute = UIFont(name: "Elley", size: 23)
        UIBarButtonItem.appearance()
            .setTitleTextAttributes([NSFontAttributeName : attribute!],
                                    forState: UIControlState.Normal)
        
        
        
        
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
        cell.userProfileImage.sd_setImageWithURL(url, placeholderImage: UIImage(named: "profile16"))
        cell.userProfileImage.layer.cornerRadius = cell.userProfileImage.bounds.width / 2
        cell.userProfileImage.clipsToBounds = true
        return cell
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBarText = searchBar.text
        removeListOfUser(self.searchBarText!)
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        //        listOfUser.removeAll()
        //        loadUserProfile()
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
    
    func removeListOfUser(name: String){
        
        self.listOfUser.removeAll()
        DataService.usernameRef.child(DataService.currentUserUID).child("friends").observeEventType(.ChildAdded, withBlock: {(snapshot) in
            let userUID = snapshot.key
            DataService.usernameRef.child(userUID).observeSingleEventOfType(.Value, withBlock: {(snapshot2) in
                if let userProfile = Username(snapshot: snapshot2) {
                    
                    if userProfile.username.containsString(name) {
                        
                        self.listOfUser.append(userProfile)
                        self.tableView.reloadData()
                    }
                }
            })
            
        })
        
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

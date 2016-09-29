//
//  InboxViewController.swift
//  Traveller
//
//  Created by Tan Yee Gene on 26/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class InboxViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    var listOfUsername = [Username]()
    var lastUsername: String!
    var lastMessage: String!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        activityIndicator.startAnimating()
        observeRecent()
        tableView.reloadData()
        if self.listOfUsername.count < 1 {
            self.activityIndicator.hidden = true
        }
        
    }
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.listOfUsername.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! InboxTableViewCell
        let username = self.listOfUsername[indexPath.row]

        
        let url = NSURL(string: username.profileImage)
        cell.userProfileImage.sd_setImageWithURL(url, placeholderImage: UIImage(named: "loading"))
        
        cell.usernameLabel.text = username.username
        
        return cell
    }
    
    
    func observeRecent(){
        DataService.usernameRef.child(DataService.currentUserUID).child("chatroom").observeEventType(.ChildAdded, withBlock: {(chatroomKeySnapshot) in
            let chatroomKey = chatroomKeySnapshot.key
            

            DataService.usernameRef.child(DataService.currentUserUID).child("chatroom").child(chatroomKey).child("userUID").observeEventType(.Value, withBlock: {(snapshot) in
                
                if snapshot.exists() {
                    
                 guard let userUID = snapshot.value as? String else {return}
                    
                    DataService.usernameRef.child(userUID).observeSingleEventOfType(.Value, withBlock: {(usernameSnapshot) in
                        
                        if let dict = Username(snapshot: usernameSnapshot) {
                            self.listOfUsername.append(dict)
                            self.tableView.reloadData()
                        }
                        
                        })
                        self.tableView.reloadData()
                        self.activityIndicator.hidden = true
                }
            })
        })
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
         if segue.identifier == "PrivateSegue"{
            let destination = segue.destinationViewController as! UINavigationController
            let controller = destination.viewControllers.first as! PrivateMessageViewController
            let index = self.tableView.indexPathForSelectedRow
            let user = self.listOfUsername[(index?.row)!]
            controller.userUID = user.userUID

        }
    }
    
    
}

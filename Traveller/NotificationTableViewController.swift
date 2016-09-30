//
//  NotificationTableViewController.swift
//  Traveller
//
//  Created by Hahaboy on 28/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit
import SDWebImage

class NotificationTableViewController: UITableViewController {

    var listOfUser = [User]()
    var strangerUID:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.usernameRef.child(User.currentUserUid()!).child("pending-friends").observeEventType(.ChildAdded, withBlock: { snapshot in
        
            DataService.usernameRef.child(snapshot.key).observeSingleEventOfType(.Value, withBlock: { userSnapshot in
                if let user = User(snapshot: userSnapshot){
                    self.listOfUser.append(user)
                    self.tableView.reloadData()
                }
            })
            self.tableView.reloadData()
    })
        
    DataService.usernameRef.child(User.currentUserUid()!).child("post").observeEventType(.Value, withBlock: { snapshot in

        DataService.postRef.child(snapshot.key).child("travellers").observeSingleEventOfType(.Value, withBlock: { userSnapshot in
//            guard let snapshotDictionary = snapshot.key as? [String:AnyObject] else { return }
//            
//            let imageURL = snapshotDictionary["true"] as? String
            
        })
        self.tableView.reloadData()
    })
    
    DataService.usernameRef.child(User.currentUserUid()!).child("pending-friends").observeEventType(.ChildRemoved, withBlock: { snapshot in
        
        for (index,i) in self.listOfUser.enumerate(){
            if i.uid == snapshot.key{
                self.listOfUser.removeAtIndex(index)
                self.tableView.reloadData()
            }
        }
    })
    
        
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfUser.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NotificationCell") as! NotificationCell
        
        let user = self.listOfUser[indexPath.row]
        
        cell.messageTextView.text = user.username + " want to add you as friend"
        let userImageUrl = user.profileImage
        let url = NSURL(string: userImageUrl)
        cell.userImageView.sd_setImageWithURL(url)
        
        cell.friendRequesterUID = user.uid
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let user = self.listOfUser[indexPath.row]
        self.strangerUID = user.uid
        performSegueWithIdentifier("goToStrangerProfile", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToStrangerProfile"{
            let nextScene = segue.destinationViewController as! StrangerProfileViewController
            nextScene.strangerUID = self.strangerUID
        }
    }
    
}

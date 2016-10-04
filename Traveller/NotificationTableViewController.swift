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
    var productID : String!
    var checker:Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = StyleKit.darkRed
        
        // Title Decoration
        self.navigationController?.navigationBarHidden =  false
        self.title = "Notification"
        let attributes: AnyObject = [ NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = attributes as? [String : AnyObject]
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Elley", size: 23.0)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        
        // navigationBar decoration
        navigationController?.navigationBar.barTintColor = StyleKit.darkRed
        
        let attribute = UIFont(name: "Elley", size: 23.0)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSFontAttributeName : attribute!], forState: .Normal)
    
        
        DataService.usernameRef.child(User.currentUserUid()!).child("pending-friends").observeEventType(.ChildAdded, withBlock: { snapshot in
        
            DataService.usernameRef.child(snapshot.key).observeSingleEventOfType(.Value, withBlock: { userSnapshot in
                if let user = User(snapshot: userSnapshot){
                    self.listOfUser.append(user)
                    self.tableView.reloadData()
                    
                }
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
        
        
        //insert notification
    DataService.usernameRef.child(User.currentUserUid()!).child("post").observeEventType(.Value, withBlock: { snapshot in
        if snapshot.hasChildren(){
            let keyArray = snapshot.value?.allKeys as! [String]
            for key in keyArray {
                print(key)
                DataService.postRef.child(key).child("travellers").observeEventType(.Value, withBlock: { travellerSnapshot in
                    if travellerSnapshot.hasChildren(){
                        DataService.postRef.child(key).observeSingleEventOfType(.Value, withBlock: { postSnapshot in
                            if let post = Post(snapshot: postSnapshot){
                                let user = User.init()
                                user.travellerNotification = true
                                user.profileImage = post.productImage
                                user.username = post.productName
                                user.uid = post.uid
                                self.productID = post.uid
                                
                                for i in self.listOfUser{
                                    if i.username == post.productName{
                                        self.checker = false
                                    }else{
                                        self.checker = true
                                    }
                                }
                                if self.checker == true{
                                    self.listOfUser.append(user)
                                    self.tableView.reloadData()
                                }
                            }
                        })
                    }
                    
                })
            }
        }
    })
        
        
        
        //remove notification
        DataService.usernameRef.child(User.currentUserUid()!).child("post").observeEventType(.Value, withBlock: { snapshot in
            if snapshot.hasChildren(){
                let keyArray = snapshot.value?.allKeys as! [String]
                for key in keyArray {
                    print(key)
                    DataService.postRef.child(key).child("travellers").observeEventType(.ChildRemoved, withBlock: { travellerSnapshot in
                        DataService.postRef.child(key).child("travellers").observeEventType(.Value, withBlock: { countSnapshot in
                            
                            if countSnapshot.childrenCount == 0{
                                for (index,i) in self.listOfUser.enumerate(){
                                    if i.uid == key{
                                        self.listOfUser.removeAtIndex(index)
                                        self.tableView.reloadData()
                                        
                                    }
                                }
                            }
                            
                        })
                    })
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
        
        if user.travellerNotification == true{
            cell.messageTextView.text = "Traveller requested on your job."
            let userImageUrl = user.profileImage
            let url = NSURL(string: userImageUrl!)
            cell.userImageView.sd_setImageWithURL(url)
            
            cell.acceptButton.hidden = true
            cell.declineButton.hidden = true
            
            return cell
        }else{
            cell.messageTextView.text = user.username! + " want to add you as friend"
            let userImageUrl = user.profileImage
            let url = NSURL(string: userImageUrl!)
            cell.userImageView.sd_setImageWithURL(url)
            
            cell.friendRequesterUID = user.uid
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let user = self.listOfUser[indexPath.row]
        if user.travellerNotification == true{
            performSegueWithIdentifier("jobRequestSegue", sender: self)
        }else{
            self.strangerUID = user.uid
            performSegueWithIdentifier("goToStrangerProfile", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToStrangerProfile"{
            let nextScene = segue.destinationViewController as! StrangerProfileViewController
            nextScene.strangerUID = self.strangerUID
        }else if segue.identifier == "jobRequestSegue" {
            let destination = segue.destinationViewController as! ListOfTravellerRequestViewController
            destination.postID = self.productID
        }
    }
    
}
        

    


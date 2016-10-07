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
    var uniqueID = [String]()
    
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
    
        //friend request notificaiton
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
                                
                                if self.listOfUser.count > 0{
                                    for i in self.listOfUser{
                                        self.uniqueID.append(i.uid!)
                                    }
                                    if !self.uniqueID.contains(post.uid){
                                        
                                        if !postSnapshot.childSnapshotForPath("RequestStatus").exists(){
                                            self.listOfUser.append(user)
                                            self.tableView.reloadData()
                                        }
                                    }
                                }else{

                                    
                                    if !postSnapshot.childSnapshotForPath("RequestStatus").exists(){
                                        self.listOfUser.append(user)
                                        self.tableView.reloadData()
                                    }
                                }
                                
                                self.removeAcceptedNotification()
//                                DataService.postRef.child(key).child("RequestStatus").observeEventType(.Value, withBlock: { acceptedSnapshot in
//                                    if acceptedSnapshot.hasChildren(){
//                                        let checkArray = acceptedSnapshot.value?.allValues as! [Int]
//                                        if !checkArray.contains(1){
//                                            self.listOfUser.append(user)
//                                            self.tableView.reloadData()
//                                            
//                                        }
//                                        
//                                    }
//                                })
                                
                                
                                
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
        
        
        //job request notification
    DataService.usernameRef.child(User.currentUserUid()!).child("RequestStatus").observeEventType(.Value, withBlock: { snapshot in
            if snapshot.hasChildren(){
                let keyArray = snapshot.value?.allKeys as! [String]
                let keyArray2 = snapshot.value?.allValues as! [Int]
                
                for (index,key2) in keyArray2.enumerate(){
                    
                    if key2 == 1{
                        DataService.postRef.child(keyArray[index]).observeEventType(.Value, withBlock: { postSnapshot in
                            if let post = Post(snapshot: postSnapshot){
                                let user = User.init()
                                user.jobNotification = true
                                user.profileImage = post.productImage
                                user.username = post.productName
                                user.uid = post.uid
                                self.listOfUser.append(user)
                                self.tableView.reloadData()
                            }
                        })
                    
                    }else{
                        //job reject notification
                        DataService.postRef.child(keyArray[index]).observeEventType(.Value, withBlock: { postSnapshot in
                            if let post = Post(snapshot: postSnapshot){
                                let user = User.init()
                                user.jobNotification = false
                                user.profileImage = post.productImage
                                user.username = post.productName
                                user.uid = post.uid
                                self.listOfUser.append(user)
                                self.tableView.reloadData()
                            }
                        })
                    }
                    
                }
            }
        })
        
    
    }
    
    //just removing local array , accepted noti will not be load
    func removeAcceptedNotification(){
        DataService.usernameRef.child(User.currentUserUid()!).child("post").observeEventType(.Value, withBlock: { snapshot in
            if snapshot.hasChildren(){
                let keyArray = snapshot.value?.allKeys as! [String]
                for key in keyArray {
                    DataService.postRef.child(key).child("RequestStatus").observeEventType(.Value, withBlock: { acceptedSnapshot in
                        if acceptedSnapshot.hasChildren(){
                            let keyArray2 = snapshot.value?.allValues as! [Int]
                            if keyArray2.contains(1){

                                for (index,x) in self.listOfUser.enumerate(){
                                    
                                    if x.uid == key{
                                        self.listOfUser.removeAtIndex(index)
                                        self.tableView.reloadData()
                                    }
                                    
                                }

                            }
                        }
                        
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
        if user.jobNotification == true{
            
            //traveller selected
            cell.messageTextView.text = "Congrats! You have been choosen to be travller!"
            let userImageUrl = user.profileImage
            let url = NSURL(string: userImageUrl!)
            cell.userImageView.sd_setImageWithURL(url)
            
            cell.acceptButton.hidden = true
            cell.declineButton.hidden = true
            
            return cell
        }else if user.jobNotification == false{
            
            //have been rejected
            
            cell.messageTextView.text = "Too bad you have been rejected."
            let userImageUrl = user.profileImage
            let url = NSURL(string: userImageUrl!)
            cell.userImageView.sd_setImageWithURL(url)
            
            cell.acceptButton.hidden = true
            cell.declineButton.hidden = true
            
            return cell
        }else if user.travellerNotification == true{
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
        
        self.strangerUID = user.uid
        if user.travellerNotification == true{
            self.productID = user.uid
            performSegueWithIdentifier("jobRequestSegue", sender: self)
        }else if user.jobNotification == true{
            performSegueWithIdentifier("DetailSegue", sender: self)
        }else if user.jobNotification == false{
            performSegueWithIdentifier("DetailSegue", sender: self)
        }else{
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
        }else if segue.identifier == "DetailSegue"{
            let nextScene = segue.destinationViewController as! DetailViewController
            nextScene.productID = self.strangerUID
        }
    }
    
    
    
    
}
        

    


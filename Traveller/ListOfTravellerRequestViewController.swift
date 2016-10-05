//
//  ListOfTravellerRequestViewController.swift
//  Traveller
//
//  Created by Tan Yee Gene on 02/10/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit
import Firebase

class ListOfTravellerRequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ListOftravellerRequestCellDelegate {
    @IBOutlet var tableView: UITableView!
    var postID : String?
    var listOfUser = [Username]()
    var strangerUID: String?
    var buttonStatus: String?
    var userUID : String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        observeTraveller()
        refreshTable()
        
        
        self.title = ""
        navigationController?.navigationBar.barTintColor = StyleKit.darkRed
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let attribute = UIFont(name: "Elley", size: 23)
        UIBarButtonItem.appearance()
            .setTitleTextAttributes([NSFontAttributeName : attribute!],
                                    forState: UIControlState.Normal)
        
        
        
        
    }
    
    func refreshTable(){
        DataService.postRef.child(self.postID!).observeEventType(.Value, withBlock: {(snapshot) in
            self.tableView.reloadData()
        })
    }
    
    func observeTraveller(){
        DataService.postRef.child(self.postID!).child("travellers").observeEventType(.ChildAdded, withBlock: {(snapshot) in
            let userKey = snapshot.key
            DataService.usernameRef.child(userKey).observeSingleEventOfType(.Value, withBlock: {(snapshot2) in
                guard let traveller = Username(snapshot: snapshot2) else {return}
                self.listOfUser.append(traveller)
                self.tableView.reloadData()
            })
            
        })
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ListOfTravellerRequestTableViewCell
        let user = self.listOfUser[indexPath.row]
        let url = NSURL(string: user.profileImage)
        cell.postID = self.postID
        cell.userUID = user.userUID
        cell.requesterProfileImg.sd_setImageWithURL(url, placeholderImage: UIImage(named: "profile16"))
        cell.requesterUsername.setTitle(user.username, forState: .Normal)
        cell.requesterProfileImg.layer.cornerRadius = cell.requesterProfileImg.bounds.width / 2
        cell.requesterProfileImg.clipsToBounds = true
        if user.trustworthy == 0 {
            cell.requesterRating.image = UIImage(named: "empty")
        } else if user.trustworthy == 1{
            cell.requesterRating.image = UIImage(named: "1")
        } else if user.trustworthy == 2 {
            cell.requesterRating.image = UIImage(named: "2")
        }else if user.trustworthy == 3 {
            cell.requesterRating.image = UIImage(named: "3")
        }else if user.trustworthy == 4 {
            cell.requesterRating.image = UIImage(named: "4")
        }else if user.trustworthy == 5 {
            cell.requesterRating.image = UIImage(named: "5")
        }
        cell.delegate = self
        
        
        DataService.postRef.child(self.postID!).child("RequestStatus").child(user.userUID).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            let status = snapshot.value as? Int
            //            print("this is userUID \(user.userUID)")
            //            print("this is status :\(status)")
            if status == 1 {
                
                cell.declinebutton.hidden = true
                cell.acceptButton.setTitle("Accepted", forState: .Normal)
                cell.acceptButton.backgroundColor = UIColor.greenColor()
                cell.declinebutton.enabled = false
                cell.acceptButton.enabled = false
            }else if status == 0 {
                cell.acceptButton.hidden = true
                cell.declinebutton.setTitle("Declined", forState: .Normal)
                cell.declinebutton.backgroundColor = UIColor.redColor()
                cell.acceptButton.enabled = false
                cell.declinebutton.enabled = false
            }
            
            DataService.postRef.child(self.postID!).child("CompletionStatus").child(user.userUID).observeEventType(.Value, withBlock: {(snapshot2) in
                let jobStatus = snapshot2.value as? Int
                print("this is snapshot2.value \(snapshot2.value)")
                if jobStatus == 1 {
                    cell.declinebutton.setTitle("Task Completed", forState: .Normal)
                    cell.declinebutton.hidden = false
                }else if jobStatus == 0 {
                    
                    cell.declinebutton.setTitle("Task Incomplete", forState: .Normal)
                    cell.declinebutton.hidden = false
                    cell.declinebutton.enabled = true
                    
                }
                
            })
        })
        return cell
    }
    
    
    func listOfTravellerRequestCellDelegate(controller: ListOfTravellerRequestTableViewCell, declineButtonStatus status: String, userUID: String) {
        self.buttonStatus = status
        self.userUID = userUID
        
        if buttonStatus == "Task Incomplete"{
             self.performSegueWithIdentifier("RatingSegue", sender: ["postID" : postID, "travellerID" : self.userUID])
        }
    }
    
   
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfUser.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let user = self.listOfUser[indexPath.row]
        self.strangerUID = user.userUID
        performSegueWithIdentifier("goToStrangerProfile", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToStrangerProfile"{
            let nextScene = segue.destinationViewController as! StrangerProfileViewController
            nextScene.strangerUID = self.strangerUID
        }else if segue.identifier == "RatingSegue"{
            let destination = segue.destinationViewController as! CompletionController
            if let dict = sender as? NSDictionary{ // change this to dictionary!!
                destination.postID = dict["postID"] as? String
                destination.travellerID = dict["travellerID"] as? String
            }
        }
    }
}

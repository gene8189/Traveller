//
//  ListOfJobTableViewController.swift
//  
//
//  Created by Hahaboy on 04/10/2016.
//
//

import UIKit
import SDWebImage

class ListOfJobTableViewController: UITableViewController, JobCellDelegate {

    
    
    var listOfJob = [Post]()
    var productID:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.usernameRef.child(User.currentUserUid()!).child("post").observeEventType(.Value, withBlock: { snapshot in
            
            if snapshot.hasChildren(){
                let keyArray = snapshot.value?.allKeys as! [String]
                for key in keyArray {
                    
                    DataService.postRef.child(key).observeEventType(.Value, withBlock: { postSnapshot in
                        guard let post = Post(snapshot: postSnapshot) else {return}

                        for (index, job) in self.listOfJob.enumerate(){
                            if job.uid == post.uid {
                                self.listOfJob.removeAtIndex(index)
                            }
                        }
                        self.listOfJob.append(post)
                        self.tableView.reloadData()
                    })
                }
            }
            
        })
        
        
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfJob.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("JobCell") as! JobCell

        let job = self.listOfJob[indexPath.row]
        
        cell.job = job
        cell.delegate = self
        DataService.postRef.child(job.uid).observeEventType(.Value, withBlock: { snapshot in
            
            if snapshot.childSnapshotForPath("travellers").exists(){
                if snapshot.childSnapshotForPath("CompletionStatus").exists(){
                    
                DataService.postRef.child(job.uid).child("CompletionStatus").observeEventType(.Value, withBlock: { completeSnapshot in
                        let completeArray = completeSnapshot.value?.allObjects as! [Int]

                        if completeArray.contains(1){
                            cell.myDetailLabel?.text = "Completed"
                        }else{
                            cell.myDetailLabel?.text = "In Progress"
                        }
                    })
                }else{
                    cell.myDetailLabel.text = "Waiting for Approval"
                }
            }else{
                cell.myDetailLabel.text = "Waiting For Travellers"
                
            }
            
        })
        
        cell.myTextLabel.text = job.productName
        let userImageUrl = job.productImage
        let url = NSURL(string: userImageUrl)
        cell.niceImageView!.sd_setImageWithURL(url)
        
        
        

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let job = self.listOfJob[indexPath.row]
        self.productID = job.uid
        
        performSegueWithIdentifier("DetailSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailSegue"{
            let nextScene = segue.destinationViewController as! DetailViewController
                nextScene.productID = self.productID
        }else if segue.identifier == "ListOfJobRequestSegue" {
            let nextScene = segue.destinationViewController as! ListOfTravellerRequestViewController
                nextScene.postID = self.productID
        }
    }
    
    func passThisPostIDToViewTravellerList(postID: String) {
        self.productID = postID
        performSegueWithIdentifier("ListOfJobRequestSegue", sender: self)
        
    }

}

//
//  ListOfJobTableViewController.swift
//  
//
//  Created by Hahaboy on 04/10/2016.
//
//

import UIKit
import SDWebImage

class ListOfJobTableViewController: UITableViewController {

    
    
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
        let cell = tableView.dequeueReusableCellWithIdentifier("JobCell")

        let job = self.listOfJob[indexPath.row]
        
        
        cell?.textLabel?.text = job.productName
        let userImageUrl = job.productImage
        let url = NSURL(string: userImageUrl)
        cell?.imageView!.sd_setImageWithURL(url)
        
        
        

        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let job = self.listOfJob[indexPath.row]
        self.productID = job.uid
        
        performSegueWithIdentifier("ListOfJobRequestSegue", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nextScene = segue.destinationViewController as! ListOfTravellerRequestViewController
            nextScene.postID = self.productID
    }

}

//
//  ReviewTableViewController.swift
//  Traveller
//
//  Created by Hahaboy on 07/10/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit

class ReviewTableViewController: UITableViewController {

    
    
    var reviewArray = [Review]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.usernameRef.child(User.currentUserUid()!).child("reviews").observeEventType(.Value, withBlock: { reviewSnapshot in
            
            let keyArray = reviewSnapshot.value?.allKeys as! [String]
            for key in keyArray{
            DataService.usernameRef.child(User.currentUserUid()!).child("reviews").child(key).observeEventType(.Value, withBlock: { reviewSnapshot2 in
                if let review = Review(snapshot: reviewSnapshot2){
                    
                    self.reviewArray.append(review)
                    self.tableView.reloadData()
                    
                        
                    }
                })
            }
        })
        
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reviewArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReviewCell")
        
        let review = self.reviewArray[indexPath.row]
        
        cell?.detailTextLabel?.text = review.poster
        
        return cell!
    }
    

}

//
//  ReviewTableViewController.swift
//  Traveller
//
//  Created by Hahaboy on 07/10/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit
import SDWebImage

class ReviewTableViewController: UITableViewController {

    
    
    var reviewArray = [Review]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.usernameRef.child(User.currentUserUid()!).child("reviews").observeEventType(.Value, withBlock: { reviewSnapshot in
            if reviewSnapshot.hasChildren(){
                let keyArray = reviewSnapshot.value?.allKeys as! [String]
                for key in keyArray{
                DataService.usernameRef.child(User.currentUserUid()!).child("reviews").child(key).observeEventType(.Value, withBlock: { reviewSnapshot2 in
                        let keyArray2 = reviewSnapshot2.value?.allKeys as! [String]
                        for key2 in keyArray2{
                        
                            DataService.usernameRef.child(User.currentUserUid()!).child("reviews").child(key).child(key2).observeEventType(.Value, withBlock: { reviewSnapshot3 in
                            
                            if let review = Review(snapshot: reviewSnapshot3){
                                
                                    DataService.usernameRef.child(review.poster!).observeEventType(.Value, withBlock: { userSnapshot in
                                        if let user = User(snapshot: userSnapshot){
                                            review.poster = user.username
                                            review.profileImage = user.profileImage
                                    
                                        self.reviewArray.append(review)
                                        self.tableView.reloadData()
                                        }
                                    })


                                    
                                }
                            })
                        }
                    })
                }
            }
        })
        
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reviewArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReviewCell")
        
        let review = self.reviewArray[indexPath.row]
        
        cell?.textLabel?.text = review.poster
        cell?.detailTextLabel?.text = review.text
        
        if let userImageUrl = review.profileImage{
        let url = NSURL(string: userImageUrl)
        cell!.imageView!.sd_setImageWithURL(url)
        cell?.imageView?.layer.cornerRadius = 20
        cell?.imageView!.layer.masksToBounds = true
        }
        
        return cell!
    }
    

}

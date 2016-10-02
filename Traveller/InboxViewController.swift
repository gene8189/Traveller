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
        navigationItem.leftBarButtonItem = editButtonItem()
        navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        tableView.separatorColor = StyleKit.darkRed
        
        
        let attribute = UIFont(name: "Elley", size: 23.0)
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName : attribute!], forState: .Normal)
        
        if self.listOfUsername.count == 0 {
            self.activityIndicator.hidden = true
        }
        
        // Title Decoration
        self.navigationController?.navigationBarHidden =  false
        self.title = "Inbox"
        let attributes: AnyObject = [ NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = attributes as? [String : AnyObject]
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Elley", size: 23.0)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.barTintColor = StyleKit.darkRed
    }
    
    override func viewDidAppear(animated: Bool) {
        activityIndicator.startAnimating()
    }
    
    func filterList() {
        
        let sortedArray = listOfUsername.sort({ $0.username > $1.username })
        listOfUsername = sortedArray
        for _ in listOfUsername{
            
        }
        self.tableView.reloadData()
        
    }
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.listOfUsername.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! InboxTableViewCell
        let username = self.listOfUsername[indexPath.row]
        
        //        cell.backgroundColor = StyleKit.skinColor.colorWithAlphaComponent(0.5)
        //
        //
        //        cell.usernameLabel.backgroundColor = UIColor(white: 1, alpha: 0.8)
        cell.usernameLabel.layer.cornerRadius = cell.usernameLabel.frame.width / 100
        
        
        let url = NSURL(string: username.profileImage)
        cell.userProfileImage.sd_setImageWithURL(url, placeholderImage: UIImage(named: "profile16"))
        cell.userProfileImage.layer.cornerRadius = cell.userProfileImage.bounds.width / 2
        cell.userProfileImage.clipsToBounds = true
        cell.usernameLabel.text = username.username
        
        return cell
    }
    
    
    func observeRecent(){
        DataService.usernameRef.child(DataService.currentUserUID).child("chatroom").observeEventType(.ChildAdded, withBlock: {(chatroomKeySnapshot) in
            let chatroomKey = chatroomKeySnapshot.key
            
            
            DataService.usernameRef.child(DataService.currentUserUID).child("chatroom").child(chatroomKey).child("userUID").observeSingleEventOfType(.Value, withBlock: {(snapshot) in
                
                if snapshot.exists() {
                    
                    guard let userUID = snapshot.value as? String else {return}
                    
                    DataService.usernameRef.child(userUID).observeSingleEventOfType(.Value, withBlock: {(usernameSnapshot) in
                        
                        if let dict = Username(snapshot: usernameSnapshot) {
                            self.listOfUsername.append(dict)
                            self.tableView.reloadData()
                        }
                        
                    })
                    self.filterList()
                    self.tableView.reloadData()
                    self.activityIndicator.hidden = true
                }
            })
        })
        
        
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: true)
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete{
            let deleteUsername = self.listOfUsername[indexPath.row]
            let usernameID = deleteUsername.userUID
            self.deleteChatroom(usernameID)
            self.listOfUsername.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    func deleteChatroom(usernameID : String) {
        DataService.usernameRef.child(DataService.currentUserUID).child("chatroom").child(DataService.currentUserUID+usernameID).removeValue()
        
        print("working")
    }
    
    @IBAction func unwindToInbox(segue: UIStoryboardSegue) {
    }
    
    //    func deleteBlog(blogID: Int){
    //        Alamofire.request(.DELETE, "https://nextacademy-ios-blog.herokuapp.com/api/v1/blogs"+String(blogID)).responseData(completionHandler: {(response) in
    //            switch response.result {
    //            case .Success(_):
    //                let temporaryBlog = self.blogs.filter({ $0.id != blogID })
    //                self.blogs = temporaryBlog
    //                self.tableView.reloadData()
    //            case .Failure(let error):
    //                print(error.localizedDescription)
    //            }
    //        })
    //    }
    
    
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

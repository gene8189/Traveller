//
//  ListOfTravellerRequestTableViewCell.swift
//  Traveller
//
//  Created by Tan Yee Gene on 02/10/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit
import Firebase

protocol ListOftravellerRequestCellDelegate {
    func listOfTravellerRequestCellDelegate(controller: ListOfTravellerRequestTableViewCell, declineButtonStatus status:String, userUID: String)
}

class ListOfTravellerRequestTableViewCell: UITableViewCell {
    var postID:String!
    var userUID: String!
    @IBOutlet var requesterProfileImg: UIImageView!
    @IBOutlet var requesterUsername: UIButton!
    @IBOutlet var requesterRating: UIImageView!
    @IBOutlet var acceptButton: UIButton!
    @IBOutlet var declinebutton: UIButton!
    var delegate: ListOftravellerRequestCellDelegate?
    
    
    
    @IBAction func onDeclineButtonPressed(sender: AnyObject) {
//        let listOfTravellerRequestCellDelegate = self.delegate
        if declinebutton.currentTitle == "Decline"{
        DataService.usernameRef.child(userUID).child("RequestStatus").updateChildValues([postID: false])
        DataService.postRef.child(self.postID).child("RequestStatus").updateChildValues([userUID: false])
        } else if declinebutton.currentTitle == "Task Incomplete" {
            
                delegate?.listOfTravellerRequestCellDelegate(self, declineButtonStatus: declinebutton.currentTitle!, userUID: userUID)
            
        
        }
    }
    
    @IBAction func onAcceptButtonPressed(sender: AnyObject) {
        
        DataService.postRef.child(self.postID).child("travellers").observeEventType(.ChildAdded, withBlock: {(snapshot) in
            DataService.postRef.child(self.postID).child("RequestStatus").updateChildValues([snapshot.key: false])
            DataService.usernameRef.child(snapshot.key).child("RequestStatus").updateChildValues([self.postID: false])
            DataService.postRef.child(self.postID).child("RequestStatus").updateChildValues([self.userUID:true])
            
            DataService.usernameRef.child(self.userUID).child("RequestStatus").updateChildValues([self.postID: true])
            DataService.postRef.child(self.postID).child("CompletionStatus").updateChildValues([self.userUID:false])
            DataService.usernameRef.child(self.userUID).child("CompletionStatus").updateChildValues([self.postID: false])
        
        })
       
    }
}
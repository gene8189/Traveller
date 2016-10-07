//
//  ProductCell.swift
//  Traveller
//
//  Created by Hahaboy on 27/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {

    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
}



class NotificationCell: UITableViewCell {
    var friendRequesterUID:String!
    
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var userImageView: UIImageView!
        
    @IBAction func onAcceptButtonPressed(sender: AnyObject) {
        DataService.usernameRef.child(User.currentUserUid()!).child("pending-friends").child(self.friendRequesterUID).removeValue()
        DataService.usernameRef.child(User.currentUserUid()!).child("friends").updateChildValues([self.friendRequesterUID:true])
        DataService.usernameRef.child(self.friendRequesterUID).child("friends").updateChildValues([User.currentUserUid()!:true])
        
    }
    
    @IBAction func onDeclineButtonPressed(sender: AnyObject) {
        
        DataService.usernameRef.child(User.currentUserUid()!).child("pending-friends").child(self.friendRequesterUID).removeValue()
        
    }
    
}

protocol JobCellDelegate{
    func passThisPostIDToViewTravellerList(postID:String)
}

class JobCell: UITableViewCell {
    
    var delegate : JobCellDelegate?
    var job:Post!
    @IBOutlet weak var myDetailLabel: UILabel!
    @IBOutlet weak var myTextLabel: UILabel!
    @IBOutlet weak var niceImageView: UIImageView!
    
    
    @IBAction func onTravellerButtonPressed(sender: AnyObject) {
        self.delegate?.passThisPostIDToViewTravellerList(self.job.uid)
        
    }
    
}

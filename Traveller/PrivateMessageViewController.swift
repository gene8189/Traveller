//
//  PrivateMessageViewController.swift
//  Traveller
//
//  Created by Tan Yee Gene on 27/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import FirebaseAuth
import FirebaseDatabase

class PrivateMessageViewController: JSQMessagesViewController {
    var messages = [JSQMessage]()
    var activityIndicator: UIActivityIndicatorView?
    var userUID : String!
    //    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        observeUser()
        observeMessage()
         navigationController?.navigationBar.barTintColor = StyleKit.darkRed
    
    }
    
    func observeUser(){
        DataService.usernameRef.child(DataService.currentUserUID).child("username").observeSingleEventOfType(.Value , withBlock: {(snapshot) in
            let senderDisplayName = snapshot.value as? String
            self.activityIndicator?.hidden = true
            self.senderId = DataService.currentUserUID
            self.senderDisplayName = senderDisplayName!
        })
        self.senderId = "placeholder"
        self.senderDisplayName = "placeholder"
        
    }
    
    
    
    func observeMessage(){
        
        DataService.usernameRef.child(DataService.currentUserUID).child("chatroom").child(DataService.currentUserUID+self.userUID).child("chat").observeEventType(.ChildAdded, withBlock: {(snapshot) in
            let chatKey = snapshot.key
            DataService.chatroomRef.child(DataService.currentUserUID+self.userUID).child(chatKey).observeSingleEventOfType(.Value, withBlock: {(snapshot2) in
                let message = Message(snapshot: snapshot2)
                print(message?.text)
                self.messages.append(JSQMessage(senderId: message?.senderID, displayName: message?.senderDisplayName, text: message?.text))
                self.scrollToBottomAnimated(true)
                
                self.finishSendingMessage()
                self.collectionView.reloadData()
            })
        })
    }
    
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
    
        sendMessage(text)
       
        
    }
    
    func sendMessage(text: String){
        // current user update
        let currentUserUIDAndUserUID = ["currentUserUID" : DataService.currentUserUID, "userUID" : self.userUID]
        DataService.usernameRef.child(DataService.currentUserUID).child("chatroom").child(DataService.currentUserUID+self.userUID).updateChildValues(currentUserUIDAndUserUID)
        let currentUserChatID = DataService.chatroomRef.child(DataService.currentUserUID+self.userUID).childByAutoId()
        let chatMessage = ["senderID": senderId, "senderDisplayName": senderDisplayName, "text": text]
        
        currentUserChatID.setValue(chatMessage)
        DataService.usernameRef.child(DataService.currentUserUID).child("chatroom").child(DataService.currentUserUID+self.userUID).child("chat").updateChildValues([currentUserChatID.key: true])
        
        
        //other user update
        let UserUIDAndCurrentUserUID = [ "userUID" : DataService.currentUserUID, "currentUserUID" :self.userUID ]
        DataService.usernameRef.child(self.userUID).child("chatroom").child(self.userUID+DataService.currentUserUID).updateChildValues(UserUIDAndCurrentUserUID)
        let userChatID = DataService.chatroomRef.child(self.userUID+DataService.currentUserUID).childByAutoId()
        let userChatMessage = ["senderID": senderId, "senderDisplayName": senderDisplayName, "text": text]
        userChatID.setValue(userChatMessage)
        
        
        DataService.usernameRef.child(self.userUID).child("chatroom").child(self.userUID+DataService.currentUserUID).child("chat").updateChildValues([userChatID.key: true])
        collectionView.reloadData()
        
    }
    
    
    override func didPressAccessoryButton(sender: UIButton!) {
        let picker = UIImagePickerController()
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let data = messages[indexPath.row]
        
        if data.senderId == DataService.currentUserUID {
            let bubble = JSQMessagesBubbleImageFactory()
            return bubble.outgoingMessagesBubbleImageWithColor(.grayColor())
        }else {
            let bubble = JSQMessagesBubbleImageFactory()
            return bubble.incomingMessagesBubbleImageWithColor(.blueColor())
        }
        
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        return cell
    }
    
    @IBAction func onHomeButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("unwindToInbox", sender: self)
    }
    
    
    
    //    override func viewDidAppear(animated: Bool) {
    //        // programmatically make activity indicator
    //
    //        activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 50, height: 50)))
    //        activityIndicator?.activityIndicatorViewStyle = .WhiteLarge
    //        activityIndicator?.color = UIColor.blackColor()
    //        self.view.addSubview(activityIndicator!)
    //        self.view.bringSubviewToFront(activityIndicator!)
    //        activityIndicator?.center = view.center
    //        activityIndicator!.startAnimating()
    //        observeUser()
    //    }
    
}

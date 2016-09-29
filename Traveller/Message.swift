//
//  Message.swift
//  Traveller
//
//  Created by Tan Yee Gene on 28/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import Foundation
import Firebase

class Message {
    var chatID : String
    var senderID: String
    var senderDisplayName : String
    var text : String
    
    init?(snapshot: FIRDataSnapshot){
        guard let dict = snapshot.value as? [String : AnyObject] else { return nil }
        chatID = snapshot.key
        
        
        if let dictSenderID = dict["senderID"] as? String {
            self.senderID = dictSenderID
        }else {
            self.senderID = ""
        }
        if let dictSenderDisplayName = dict["senderDisplayName"] as? String {
            self.senderDisplayName = dictSenderDisplayName
            
        }else {
            self.senderDisplayName = ""
        }
        if let dictText = dict["text"] as? String {
            self.text = dictText
            
        }else {
            self.text = ""
        }
    }

}
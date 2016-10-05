//
//  Username.swift
//  Traveller
//
//  Created by Tan Yee Gene on 27/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth


class Username {
    var userUID : String
    var profileImage : String
    var description : String
    var username : String
    var trustworthy : Int
    var friends : [String]
    
    init?(snapshot: FIRDataSnapshot){
        guard let dict = snapshot.value as? [String : AnyObject] else { return nil }
        userUID = snapshot.key
        
        if let dictProfileImage = dict["profileImage"] as? String {
            self.profileImage = dictProfileImage
        }else {
            self.profileImage = ""
        }
        if let dictDescription = dict["self-description"] as? String {
            self.description = dictDescription
        }else {
            self.description = ""
        }
        if let dictUsername = dict["username"] as? String {
            self.username = dictUsername
        }else {
            self.username = ""
        }
        if let dictTrustworthy = dict["trustworthy"] as? Int {
            self.trustworthy = dictTrustworthy
        }else {
            self.trustworthy = 0
        }
        if let dictFriends = dict["friends"] as? [String] {
            self.friends = dictFriends
        }else {
            self.friends = [""]
        }
    }
}
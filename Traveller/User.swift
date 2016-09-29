//
//  User.swift
//  Traveller
//
//  Created by Hahaboy on 26/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import Foundation
import Firebase

class User{
    
    var uid:String
    var username: String
    var profileImage: String
    var description : String
    var rating: String
    
    init?(snapshot: FIRDataSnapshot){
        
        self.uid = snapshot.key
        
        guard let dict = snapshot.value as? [String: AnyObject] else { return nil }
        
        if let dictUsername = dict["username"] as? String{
            self.username = dictUsername
        }else{
            self.username = ""
        }
        
        if let dictPImage = dict["profileImage"] as? String{
            self.profileImage = dictPImage
        }else{
            self.profileImage = ""
        }
        
        if let dictDescription = dict["self-description"] as? String{
            self.description = dictDescription
        }else{
            self.description = ""
        }
        
        if let dictRating = dict["trustworthy"] as? String{
            self.rating = dictRating
        }else{
            self.rating = ""
        }
    }

    class func currentUserUid() -> String? {
        return NSUserDefaults.standardUserDefaults().valueForKey("userUID") as? String
    }
}
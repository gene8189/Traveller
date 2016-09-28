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
    
    class func currentUserUid() -> String? {
        return NSUserDefaults.standardUserDefaults().valueForKey("userUID") as? String
    }
}
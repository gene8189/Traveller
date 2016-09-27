//
//  DataService.swift
//  Traveller
//
//  Created by Tan Yee Gene on 27/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

struct DataService {
    
    static var rootRef = FIRDatabase.database().reference()
    static var usernameRef = FIRDatabase.database().reference().child("Usernames")
    static var userRef = FIRDatabase.database().reference().child("users")
    static var postRef = FIRDatabase.database().reference().child("posts")
}
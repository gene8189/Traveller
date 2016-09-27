//
//  DataService.swift
//  Traveller
//
//  Created by Hahaboy on 26/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct DataService {
    static var rootRef = FIRDatabase.database().reference()
    static var userRef = FIRDatabase.database().reference().child("users")
    static var postRef = FIRDatabase.database().reference().child("posts")
}
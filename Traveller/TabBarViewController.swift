//
//  TabBarViewController.swift
//  Traveller
//
//  Created by Tan Yee Gene on 29/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = StyleKit.lighterRed
//        DataService.usernameRef.child(DataService.currentUserUID).child("chatroom").observeEventType(.Value, withBlock: {(snapshot) in
//            self.setTabBarItemImage("lock")
        

        DataService.usernameRef.child(DataService.currentUserUID).child("pending-friends").observeEventType(.ChildAdded, withBlock: {(snapshot2) in
            self.setTabBarItemImage("lock")
        })
        
        DataService.usernameRef.child(DataService.currentUserUID).child("pending-friends").observeEventType(.ChildRemoved, withBlock: {(snapshot3) in
            self.setTabBarItemImage("bell2")
        })
    }
    
    
    func setTabBarItemImage(image:String){
        let items = self.tabBar.items![2]
        items.image = UIImage(named: image)
    }
    
}

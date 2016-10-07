//
//  User.swift
//  Traveller
//
//  Created by Hahaboy on 26/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import Foundation
import Firebase

class Post{
    
    var uid:String
    var collectionMethod: String
    var productName: String
    var location : String
    var price: String
    var productImage: String
    var posterUID: String
    var date: Double
    var posterUsername:String?
    var postStatus:String?
    
    init?(snapshot: FIRDataSnapshot){
        
        self.uid = snapshot.key
        
        guard let dict = snapshot.value as? [String: AnyObject] else { return nil }
        
        if let dictCollectionMethod = dict["collectionMethod"] as? String{
            self.collectionMethod = dictCollectionMethod
        }else{
            self.collectionMethod = ""
        }
        
        if let dictProductImage = dict["imgurl"] as? String{
            self.productImage = dictProductImage
        }else{
            self.productImage = ""
        }
        
        if let dictProductName = dict["productName"] as? String{
            self.productName = dictProductName
        }else{
            self.productName = ""
        }
        
        if let dictPrice = dict["price"] as? String{
            self.price = dictPrice
        }else{
            self.price = ""
        }
        
        if let dictPoster = dict["posterUID"] as? String{
            self.posterUID = dictPoster
        }else{
            self.posterUID = ""
        }
        
        if let dictLocation = dict["location"] as? String{
            self.location = dictLocation
        }else{
            self.location = ""
        }
        
        if let dictDate = dict["created_at"] as? Double{
            self.date = dictDate
        }else{
            self.date = 0.0
        }
    }
    
}
//
//  Review.swift
//  Traveller
//
//  Created by Hahaboy on 07/10/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit
import Firebase


class Review{
    var poster:String?
    var text:String?
    var star:Int?
    
    
    init?(snapshot: FIRDataSnapshot){
        
        self.poster = snapshot.key
        
        guard let dict = snapshot.value as? [String: AnyObject] else { return nil }
        
        if let dictText = dict["review"] as? String{
            self.text = dictText
        }else{
            self.text = ""
        }
        
        if let dictStar = dict["starCount"] as? Int{
            self.star = dictStar
        }else{
            self.star = 0
        }
        
    }
}

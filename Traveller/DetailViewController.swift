//
//  DetailViewController.swift
//  Traveller
//
//  Created by Hahaboy on 27/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var collectionMethodLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var post:Post!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let post = self.post{
            self.productNameLabel.text = "Product Name: " + post.productName
            self.priceLabel.text = "Price: RM" + post.price
            self.locationLabel.text = "Location: " + post.location
            self.collectionMethodLabel.text = "Collection Method: " + post.collectionMethod
            let userImageUrl = post.productImage
            let url = NSURL(string: userImageUrl)
            self.productImageView.sd_setImageWithURL(url)
            self.usernameButton.setTitle(post.posterUsername, forState: .Normal)
        }
        
    }
    @IBAction func onIWantThisJobButtonPressed(sender: AnyObject) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nextScene = segue.destinationViewController as! StrangerProfileViewController
        nextScene.strangerUID = self.post.posterUID
    }
    
}

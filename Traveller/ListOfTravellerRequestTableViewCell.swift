//
//  ListOfTravellerRequestTableViewCell.swift
//  Traveller
//
//  Created by Tan Yee Gene on 02/10/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit

class ListOfTravellerRequestTableViewCell: UITableViewCell {
    @IBOutlet var requesterProfileImg: UIImageView!
    @IBOutlet var requesterUsername: UIButton!
    @IBOutlet var requesterRating: UIImageView!
    
    
    @IBOutlet var acceptButton: UIButton!
    @IBOutlet var declinebutton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

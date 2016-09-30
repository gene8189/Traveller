//
//  InboxTableViewCell.swift
//  Traveller
//
//  Created by Tan Yee Gene on 27/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit

class InboxTableViewCell: UITableViewCell {
    @IBOutlet var userProfileImage: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var lastReplyLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
                
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}

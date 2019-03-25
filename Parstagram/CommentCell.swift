//
//  CommentCell.swift
//  Parstagram
//
//  Created by Yash Kakodkar on 3/16/19.
//  Copyright © 2019 Yash Kakodkar. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

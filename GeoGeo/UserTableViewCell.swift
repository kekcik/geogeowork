//
//  UserTableViewCell.swift
//  GeoGeo
//
//  Created by Kirill Averyanov on 19/01/2017.
//  Copyright © 2017 Иван Трофимов. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var gotoChatButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

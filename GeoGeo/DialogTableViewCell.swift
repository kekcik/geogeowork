//
//  DialogTableViewCell.swift
//  GeoGeo
//
//  Created by Kirill Averyanov on 25/01/2017.
//  Copyright © 2017 Иван Трофимов. All rights reserved.
//

import UIKit

class DialogTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

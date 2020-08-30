//
//  PrincessCell.swift
//  princonnectGuide
//
//  Created by 金超 on 2020/8/8.
//  Copyright © 2020 jinchao. All rights reserved.
//

import UIKit

class PrincessCell: UITableViewCell {

    @IBOutlet weak var characterIcon: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

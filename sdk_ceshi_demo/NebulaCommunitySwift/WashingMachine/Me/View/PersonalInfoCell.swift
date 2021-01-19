//
//  PersonalInfoCell.swift
//  Tracker
//
//  Created by 张丹丹 on 16/9/7.
//  Copyright © 2016年 张丹丹. All rights reserved.
//

import UIKit

class PersonalInfoCell: UITableViewCell {

    @IBOutlet weak var inBtn: UIImageView!
    @IBOutlet weak var rightW: NSLayoutConstraint!
    @IBOutlet weak var accessLabel: UILabel!
    @IBOutlet weak var txtLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        txtLabel.textColor = THEMEBLACKCOLOR
        accessLabel.textColor = THEMEBLACKCOLOR
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  MeCell.swift
//  WashingMachine
//
//  Created by 张丹丹 on 16/10/28.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

import UIKit

class MeCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.textColor = THEMEBLACKCOLOR
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

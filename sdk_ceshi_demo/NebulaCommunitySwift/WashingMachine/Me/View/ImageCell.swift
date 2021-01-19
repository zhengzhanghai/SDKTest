//
//  ImageCell.swift
//  WashingMachine
//
//  Created by 张丹丹 on 16/11/11.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var imageV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

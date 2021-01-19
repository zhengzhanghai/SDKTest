//
//  NewsADSCell.swift
//  WashingMachine
//
//  Created by 郑章海 on 2020/10/14.
//  Copyright © 2020 Eteclabeteclab. All rights reserved.
//

import UIKit
import Kingfisher

class NewsADSCell: BaseTableViewCell {

    func config(_ model: SSPADSModel) {
        titleLabel.text = model.title
        despLabel.text = model.desc
  
        icon.kf.setImage(with: URL.init(string: model.image),
                         placeholder: nil,
                         options: [.transition(ImageTransition.fade(1))])
    }

    override func createUI() {
        
        selectionStyle = .none
        
        contentView.addSubview(icon)
        contentView.addSubview(titleLabel)
        contentView.addSubview(despLabel)
    }
    
    
    lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: BOUNDS_WIDTH-97, y: 22, width: 80, height: 80)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor_0x(0xf8f8f8)
        return imageView
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 17, y: 22, width: BOUNDS_WIDTH-121, height: 45)
        label.font = font_PingFangSC_Regular(15)
        label.textColor = UIColor_0x(0x333333)
        label.numberOfLines = 2
        return label
    }()
    lazy var despLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 17, y: 67, width: BOUNDS_WIDTH-121, height: 35)
        label.font = font_PingFangSC_Regular(12)
        label.textColor = UIColor_0x(0x848484)
        label.numberOfLines = 2
        return label
    }()
}

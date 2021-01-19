//
//  NewsTablewCell.swift
//  WashingMachine
//
//  Created by Harious on 2018/1/25.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit
import Kingfisher

class NewsTablewCell: BaseTableViewCell {

    func config(_ model: NewsModel) {
        titleLabel.text = model.title
        despLabel.text = model.desp
//        commentLabel.text = model.commentCountStr
        supportLabel.text = model.goodCount?.stringValue ?? "0"
        markLabel.text = model.tagStr
        
        icon.kf.setImage(with: URL.init(string: model.logo ?? ""),
                         placeholder: nil,
                         options: [.transition(ImageTransition.fade(1))])
        
//        commentLabel.sizeToFit()
        supportLabel.sizeToFit()
        
//        commentLabel.hz_x = commentIcon.frame.maxX + 3
//        supportIcon.hz_x = commentLabel.frame.maxX + 20
//        supportLabel.hz_x = supportIcon.frame.maxX + 3
    }

    override func createUI() {
        
        selectionStyle = .none
        
        contentView.addSubview(icon)
        contentView.addSubview(titleLabel)
        contentView.addSubview(despLabel)
//        contentView.addSubview(commentIcon)
//        contentView.addSubview(commentLabel)
        contentView.addSubview(markLabel)
        contentView.addSubview(supportIcon)
        contentView.addSubview(supportLabel)
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
    lazy var markLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 17, y: 117, width: 50, height: 18)
        label.font = font_PingFangSC_Regular(12)
        label.textColor = UIColor_0x(0x0f86e1)
        label.backgroundColor = UIColor_0x(0xe2f2ff)
        label.textAlignment = .center
        label.setRoundCornerRadius()
        return label
    }()
    lazy var commentIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 87, y: 117, width: 18, height: 15)
        imageView.hz_centerY = self.markLabel.hz_centerY
        imageView.image = #imageLiteral(resourceName: "comment")
        return imageView
    }()
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 105, y: 117, width: 20, height: 18)
        label.font = font_PingFangSC_Regular(13)
        label.textColor = UIColor_0x(0x848484)
        label.text = "0"
        label.sizeToFit()
        label.hz_centerY = self.markLabel.hz_centerY
        return label
    }()
    lazy var supportIcon: UIImageView = {
        let imageView = UIImageView()
//        imageView.frame = CGRect(x: 125, y: 117, width: 18, height: 15)
        imageView.frame = CGRect(x: 87, y: 117, width: 18, height: 15)
        imageView.hz_centerY = self.markLabel.hz_centerY
        imageView.image = #imageLiteral(resourceName: "support")
        return imageView
    }()
    lazy var supportLabel: UILabel = {
        let label = UILabel()
//        label.frame = CGRect(x: 146, y: 117, width: 20, height: 18)
        label.frame = CGRect(x: 105, y: 117, width: 120, height: 18)
        label.font = font_PingFangSC_Regular(13)
        label.textColor = UIColor_0x(0x848484)
        label.text = "0"
        label.sizeToFit()
        label.hz_centerY = self.markLabel.hz_centerY
        return label
    }()

}





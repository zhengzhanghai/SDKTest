//
//  RecommendNewsCell.swift
//  WashingMachine
//
//  Created by zzh on 2017/8/16.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit
import Kingfisher

class RecommendNewsCell: BaseTableViewCell {
    
    var icon: UIImageView!
    var titleLabel: UILabel!
    var timeLabel: UILabel!
    
    func config(_ model: NewsModel?) {
        titleLabel.text = model?.title
        timeLabel.text = timeStringFromTimeStamp(timeStamp: (model?.createTime?.doubleValue ?? 0))
        icon.kf.indicatorType = .activity
        icon.kf.setImage(with: URL.init(string: model?.logo ?? ""),
                         placeholder: nil,
                         options: [.transition(ImageTransition.fade(1))])
    }
    
    func testConfig() {
        titleLabel.text = "测试新闻测试新闻测试新闻测试新闻测试新闻测试新闻测试新闻测试新闻测试新闻测试新闻测试新闻测试新闻测试新闻测试新闻测试新闻测试新闻测试新闻测试新闻测试新闻测试新闻测试新闻测试新闻测试新闻测试新闻测试新闻测试新闻测试新闻测试新闻测试新闻测试新闻测试新闻测试新闻测试新闻测试新闻测试新闻测试新闻"
        timeLabel.text = "2017-09-08 88:88:88"
        icon.kf.setImage(with: URL.init(string: "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1920636237,3998407039&fm=26&gp=0.jpg"))
    }
    
    override func createUI() {
        icon = UIImageView()
        icon.contentMode = .scaleAspectFill
        icon.backgroundColor = UIColor_0x(0xf8f8f8)
        contentView.addSubview(icon)
        timeLabel = createLabel("",
                                textColor: UNDERTINTCOLOR,
                                font: UIFont.systemFont(ofSize: 12.0),
                                superView: contentView)
        titleLabel = createLabel("",
                                 textColor: DEEPCOLOR,
                                 font: UIFont.systemFont(ofSize: 16),
                                 superView: contentView)
        titleLabel.numberOfLines = 0
        let separateLine = UIView()
        contentView.addSubview(separateLine)
        separateLine.backgroundColor = UIColorRGB(243, 248, 251)
        
        icon.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.equalTo(12)
            make.width.equalTo(80)
            make.height.equalTo(60)
            make.bottom.equalTo(-12)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.icon)
            make.left.equalTo(15)
            make.right.equalTo(self.icon.snp.left).offset(-10)
            make.height.lessThanOrEqualTo(45)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.bottom.equalTo(self.icon)
            make.right.equalTo(self.icon.snp.left).offset(10)
        }
        separateLine.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }

}

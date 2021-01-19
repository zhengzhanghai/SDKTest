//
//  SchoolAccreditationHeaderView.swift
//  WashingMachine
//
//  Created by zzh on 2017/5/5.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class SchoolAccreditationHeaderView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createUI() {
        self.image = UIImage(named: "school_accreditation_bg")
        
        let explainLabel = UILabel()
        explainLabel.textColor = UIColor(rgb: 0xffffff)
        explainLabel.font = UIFont.systemFont(ofSize: 14)
        explainLabel.numberOfLines = 0
        explainLabel.text = "为了给您提供便捷高效的洗衣服务,\n请选择您的常住学校"
        explainLabel.textAlignment = NSTextAlignment.center
        self.addSubview(explainLabel);
        explainLabel.snp.makeConstraints { (make) in
            make.width.equalTo(BOUNDS_WIDTH-32)
            make.bottom.equalTo(-12)
            make.centerX.equalToSuperview()
        }
        
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor(rgb: 0xffffff)
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.numberOfLines = 0
        titleLabel.text = "Hi~感谢选择星云社区"
        titleLabel.textAlignment = NSTextAlignment.center
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.width.equalTo(BOUNDS_WIDTH-32)
            make.bottom.equalTo(explainLabel.snp.top).offset(-12)
            make.centerX.equalToSuperview()
        }
    }
    
}

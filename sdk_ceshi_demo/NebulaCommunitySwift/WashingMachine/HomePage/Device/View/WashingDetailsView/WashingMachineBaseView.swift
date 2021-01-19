//
//  WashingMachineBaseView.swift
//  WashingMachine
//
//  Created by zzh on 17/3/7.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class WashingMachineBaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSub()
        self.addShadow(offset: CGSize(width: 0, height: 4), opacity: 1, color: UIColor.black.withAlphaComponent(0.1), radius: 10)
        self.layer.cornerRadius = 20
    }
    
    func refreshUI(model: WashingModel) {
        self.titleLabel.text = model.showName ?? ""
        self.addTagView(model: model)
        dateLabel.text = String(format: "上次消毒时间:%@", timeStringFromTimeStamp(timeStamp: (model.lastCleanTime ?? 0).doubleValue))
    }
    
    fileprivate func addTagView(model: WashingModel) {
        self.tabBGView.removeAllSubView()
        self.tabBGView.addSubview(self.usingView)
        if isEmpty(model: model)  {
            self.usingView.text = "空闲"
        } else {
            if model.onOffStatus == 0 {
                self.usingView.text = "离线"
            } else {
                if model.washStatus == 3 {
                    self.usingView.text = "已预约"
                } else {
                    self.usingView.text = "使用中"
                }
            }
        }
        self.usingView.frame = CGRect(x: 0, y: 0, width: 48, height: 24)
        
        var tmpView = self.usingView
        
        if model.isUse == 1 {
            self.tabBGView.addSubview(self.usualView)
            self.usualView.frame = CGRect(x: tmpView.hz_x+tmpView.hz_width+8, y: 0, width: 48, height: 24)
            tmpView = self.usualView
        }
        
    }
    
    // 判断设备是否在线
    fileprivate func isEmpty(model: WashingModel) -> Bool {
        if model.onOffStatus != 0 {
            if model.washStatus == 2 {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    fileprivate lazy var auxiliaryView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    fileprivate lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "location_black")
        return imageView
    }()

    fileprivate lazy var usingView: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(rgb: 0xF5FAFF)
        label.layer.cornerRadius = 4
        label.textColor = UIColor(rgb: 0x3399ff)
        label.hz_height = 24
        label.font = font_PingFangSC_Regular(11)
        label.textAlignment = .center
        return label
    }()
    
    fileprivate lazy var usualView: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(rgb: 0xF5FAFF)
        label.layer.cornerRadius = 4
        label.textColor = UIColor(rgb: 0x3399ff)
        label.hz_height = 24
        label.font = font_PingFangSC_Regular(11)
        label.textAlignment = .center
        label.text = "常用"
        return label
    }()
    
    fileprivate func addSub() {
        self.addSubview(auxiliaryView)
        self.addSubview(self.icon)
        self.addSubview(self.titleLabel)
        self.addSubview(self.tabBGView)
        self.addSubview(self.dateLabel)
      
        auxiliaryView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        icon.snp_makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(4)
            make.width.height.equalTo(24)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.centerY.equalTo(icon)
            make.right.equalTo(-16)
        }
        tabBGView.snp.makeConstraints { (make) in
            make.top.equalTo(icon.snp.bottom).offset(16)
            make.left.equalTo(16)
            make.width.equalTo(48*2+8)
            make.height.equalTo(24)
            make.bottom.equalTo(-24)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-24)
            make.centerY.equalTo(tabBGView)
        }
    }
    
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = font_PingFangSC_Medium(14)
        label.textColor = DEEPCOLOR
        return label
    }()
    
    fileprivate lazy var tabBGView: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0xAAAAAA)
        label.font = font_PingFangSC_Regular(11)
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//
//  NebryDeviceFloorCell.swift
//  WashingMachine
//
//  Created by Harious on 2017/12/29.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class NebryDeviceFloorCell: BaseTableViewCell {
    
    func configData(_ floor: School) {
        floorNameLabel.text = floor.showName
        
        self.deviceNumberBGView.removeAllSubView()
        
        var drayCount: Int = 0
        var tmpView : UIView?
        for deviceType in floor.deviceTypeList {
            
            let type = Device.type(deviceType.deviceType)
            
            switch type {
            case .pulsatorWasher:
                if self.washerNumberLabel.superview == nil {
                    self.addDeviceContView(self.washerNumberLabel, "\(deviceType.sum ?? 0)台洗衣机", &tmpView)
                } else {
                    self.washerNumberLabel.text = "\(deviceType.sum ?? 0)台洗衣机"
                }
            case .blower:
                self.addDeviceContView(self.blowerNumberLabel, "\(deviceType.sum ?? 0)台吹风机", &tmpView)
            case .dryer:
                drayCount += (deviceType.sum ?? 0)
                if self.dryerNumberLabel.superview == nil {
                    self.addDeviceContView(self.dryerNumberLabel, "\(drayCount)台干衣机", &tmpView)
                } else {
                    self.dryerNumberLabel.text = "\(drayCount)台干衣机"
                }
            case .XXJ:
                self.addDeviceContView(self.xxjNumberLabel, "\(deviceType.sum ?? 0)台洗鞋机", &tmpView)
            case .condensateBeads:
                self.addDeviceContView(self.condensateBeadsNumberLabel, "\(deviceType.sum ?? 0)台洗衣凝珠", &tmpView)
            case .rollerWasher:
                self.addDeviceContView(self.rollerWasherNumberLabel, "\(deviceType.sum ?? 0)台滚筒洗衣机", &tmpView)
            default : break
            }
            
        }
    }
    
    fileprivate func addDeviceContView(_ contentLabel: UILabel, _ text: String?, _ tmpView: inout UIView?) {
        self.deviceNumberBGView.addSubview(contentLabel)
        contentLabel.text = text
        contentLabel.snp.makeConstraints({ (make) in
            if tmpView == nil {
                make.left.equalToSuperview()
            } else {
                make.left.equalTo(tmpView!.snp.right).offset(floatFromScreen(4))
            }
            make.top.bottom.equalToSuperview()
            make.width.equalTo(contentLabel.textWidth + floatFromScreen(8))
        })
        
        tmpView = contentLabel
    }
    
    override func createUI() {
        self.selectionStyle = .none
        
        self.contentView.backgroundColor = UIColor_0x(0xefeff0)
        
        self.contentView.addSubview(self.contentBGView)
        self.contentBGView.addSubview(self.floorNameLabel)
        self.contentBGView.addSubview(self.deviceNumberBGView)
        
        self.contentBGView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(10)
            make.bottom.equalToSuperview()
        }
        self.floorNameLabel.snp.makeConstraints { ( make) in
            make.left.top.equalTo(10)
            make.right.equalTo(-10)
        }
        self.deviceNumberBGView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(self.floorNameLabel.snp.bottom).offset(10)
            make.height.equalTo(20)
            make.bottom.equalTo(-10)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var contentBGView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    var floorNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor_0x(0x3e3e3e)
        label.numberOfLines = 0
        return label
    }()
    
    var deviceNumberBGView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var washerNumberLabel: UILabel = { [unowned self] in
        return self.createDeviceNumberLabel(Device.color(.pulsatorWasher))
    }()
    
    lazy var blowerNumberLabel: UILabel = { [unowned self] in
        return self.createDeviceNumberLabel(Device.color(.blower))
    }()
    
    lazy var dryerNumberLabel: UILabel = { [unowned self] in
        return self.createDeviceNumberLabel(Device.color(.dryer))
    }()
    
    lazy var xxjNumberLabel: UILabel = { [unowned self] in
        return self.createDeviceNumberLabel(Device.color(.XXJ))
    }()
    
    lazy var condensateBeadsNumberLabel: UILabel = { [unowned self] in
        return self.createDeviceNumberLabel(Device.color(.condensateBeads))
    }()
    
    lazy var rollerWasherNumberLabel: UILabel = { [unowned self] in
        return self.createDeviceNumberLabel(Device.color(.rollerWasher))
    }()
    
    fileprivate func createDeviceNumberLabel(_ contentColor: UIColor) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: floatFromScreen(9.5))
        label.textColor = contentColor
        label.layer.cornerRadius = 10
        label.layer.borderColor = contentColor.cgColor
        label.layer.borderWidth = 0.5
        label.textAlignment = .center
        label.clipsToBounds = true
        return label
    }


}








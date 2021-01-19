//
//  DetailsChoosePatternView.swift
//  WashingMachine
//
//  Created by zzh on 17/3/7.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit
import Kingfisher

class DetailsChoosePatternView: UIView {
    
    fileprivate var packageArray: [PackageModel]!
    fileprivate let baseTag = 7896
    fileprivate var selectedBtn: UIButton!
    fileprivate var selectIcons: [UIImageView] = [UIImageView]()
    
    func currentPackageId() -> String {
        let model = packageArray[self.selectedBtn.tag - baseTag]
        return model.id?.stringValue ?? "-1"
    }
    
    func configUI(_ models: [PackageModel]) {
        if models.count == 0 {
            return
        }
        self.packageArray = models
        
        var tmpBtn = UIButton() // 辅助布局
        self.addSubview(tmpBtn)
        tmpBtn.frame  = CGRect(x: 0, y: 0, width: 0, height: 0)
        for i in 0 ..< models.count {
            let bgButton = UIButton()
            self.addSubview(bgButton)
            bgButton.backgroundColor = .white
            bgButton.adjustsImageWhenHighlighted = false
            bgButton.tag = baseTag + i
            bgButton.layer.cornerRadius = 8
            bgButton.addTarget(self, action: #selector(clickBtn(_:)), for: UIControl.Event.touchUpInside)
            bgButton.snp.makeConstraints({ (make) in
                make.top.equalTo(tmpBtn.snp.bottom).offset( i == 0 ? 0 : 16)
                make.left.right.equalToSuperview()
                if i == models.count - 1 {
                    make.bottom.equalToSuperview()
                }
            })
            tmpBtn = bgButton
            
            let icon = UIImageView()
            bgButton.addSubview(icon)
            icon.contentMode = .scaleAspectFill
            icon.kf.setImage(with: URL.init(string: models[i].icon ?? ""),
                             placeholder: nil,
                             options: [.transition(ImageTransition.fade(1))])
            icon.snp.makeConstraints({ (make) in
                make.top.equalTo(16)
                make.left.equalTo(0)
                make.width.equalTo(72)
                make.height.equalTo(48)
            })
            
            let titleLabel = UILabel()
            bgButton.addSubview(titleLabel)
            titleLabel.textColor = UIColor(rgb: 0x333333)
            titleLabel.font = font_PingFangSC_Medium(14)
            titleLabel.text = models[i].name
            titleLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(72)
                make.right.equalTo(-130)
                make.height.greaterThanOrEqualTo(20)
                make.bottom.equalTo(icon.snp.centerY).offset(-4)
            })
            
            let despLabel = UILabel()
            bgButton.addSubview(despLabel)
            despLabel.numberOfLines = 0
            despLabel.textColor = UIColor(rgb: 0x999999)
            despLabel.font = font_PingFangSC_Regular(12)
            despLabel.text = models[i].desp
            despLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(titleLabel)
                make.top.equalTo(icon.snp.centerY).offset(4)
                make.right.equalTo(-130)
                make.bottom.equalTo(-22)
            })
            
            let selectIcon = UIImageView(image: UIImage(named: "pay_choose"))
            bgButton.addSubview(selectIcon)
            self.selectIcons.append(selectIcon)
            selectIcon.snp.makeConstraints({ (make) in
                make.right.equalTo(-24)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(24)
            })
            
            let moneyLabel = UILabel()
            bgButton.addSubview(moneyLabel)
            moneyLabel.textColor = UIColor(rgb: 0xFF7733)
            moneyLabel.font = font_PingFangSC_Medium(12)
            let priceStr = String(format: "%.2f", models[i].spend!.floatValue/100.0)
            let money = priceStr + " " + "元"
            let priceAttStr = NSMutableAttributedString(string: money)
            priceAttStr.addAttributes([NSAttributedString.Key.font: font_PingFangSC_Medium(16)], range: (priceStr as NSString).range(of: priceStr))
            moneyLabel.attributedText = priceAttStr
            moneyLabel.snp.makeConstraints({ (make) in
                make.right.equalTo(-64)
                make.centerY.equalToSuperview()
            })
            
            if i == 0 {
                self.selectedBtn = bgButton
                selectIcon.image = UIImage(named: "pay_choose_ed")
            }
        }
    }
    
    @objc fileprivate func clickBtn(_ btn: UIButton) {
        if btn.tag == selectedBtn.tag {
            return
        }
        self.selectedBtn = btn
        for i in 0 ..< selectIcons.count {
            let icon = selectIcons[i]
            icon.image = UIImage(named: "pay_choose")
        }
        
        let currentIcon = selectIcons[btn.tag-baseTag]
        currentIcon.image = UIImage(named: "pay_choose_ed")
    }
    
    deinit {
        ZZPrint("DetailsChoosePatternView  deinit")
    }
}

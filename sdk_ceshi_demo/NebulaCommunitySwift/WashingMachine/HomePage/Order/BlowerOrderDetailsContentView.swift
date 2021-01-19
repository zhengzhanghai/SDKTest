//
//  BlowerOrderDetailsContentView.swift
//  WashingMachine
//
//  Created by zzh on 2017/7/21.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class BlowerOrderDetailsContentView: OrderDetailsContentView {
    
    convenience init(order: OrderDetailsModel) {
        self.init(orderModel: order)
        self.addAuthCodeViewIfNeed(order: order)
    }
    
    lazy var codeBGView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 36
        view.addShadow(offset: CGSize(width: 0, height: 4),
                       opacity: 1,
                       color: UIColor(rgb: 0x000000).withAlphaComponent(0.1),
                       radius: 10)
        return view
    }()
    lazy var codeTagLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x666666)
        label.font = font_PingFangSC_Regular(14)
        label.text = "验证码"
        return label
    }()
    lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x333333)
        label.font = font_PingFangSC_Medium(24)
        return label
    }()
    
    private func addAuthCodeViewIfNeed(order: OrderDetailsModel) {
        guard let authCode = order.drierPassword, authCode.count >= 2 else {
            return
        }
        
        scrollView.snp.updateConstraints { (make) in
            make.top.equalTo(108)
        }
        
        codeLabel.text = authCode
        self.addSubview(codeBGView)
        codeBGView.addSubview(codeTagLabel)
        codeBGView.addSubview(codeLabel)
        
        codeBGView.snp.makeConstraints { (make) in
            make.centerY.equalTo(scrollView.snp.top)
            make.centerX.equalToSuperview()
            make.width.equalTo(247)
            make.height.equalTo(72)
        }
        codeTagLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        codeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(32)
        }
    }

}

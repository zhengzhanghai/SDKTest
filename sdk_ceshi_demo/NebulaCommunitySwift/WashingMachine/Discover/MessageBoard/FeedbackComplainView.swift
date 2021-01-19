//
//  FeedbackComplainView.swift
//  WashingMachine
//
//  Created by zzh on 2017/6/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class FeedbackComplainView: UIView {
    
    var clickComplaintClourse:(()->())?
    
    convenience init(frame: CGRect, _ text: String = "      吐个槽......") {
        self.init(frame: frame)
        createUI(text)
    }
    
    fileprivate func createUI(_ text: String) {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 1))
        path.addLine(to: CGPoint(x: BOUNDS_WIDTH, y: 1))
        path.addLine(to: CGPoint(x: BOUNDS_WIDTH, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        self.layer.shadowPath = path
        self.layer.shadowColor = UIColorRGB(222, 222, 222, 1).cgColor
        self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 0.5
        
        let complaintLabel = UILabel()
        complaintLabel.isUserInteractionEnabled = true
        complaintLabel.layer.cornerRadius = 3
        complaintLabel.clipsToBounds = true
        complaintLabel.backgroundColor = UIColorRGB(241, 241, 241, 1)
        complaintLabel.textColor = UIColor(rgb: 0xaaaaaa)
        complaintLabel.font = UIFont.systemFont(ofSize: 15)
        complaintLabel.text = text
        complaintLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickComplaint)))
        addSubview(complaintLabel)
        complaintLabel.snp.makeConstraints { (make) in
            make.left.equalTo(9)
            make.centerY.equalToSuperview()
            make.right.equalTo(-9)
            make.height.equalTo(30)
        }
    }
    
    
    
    @objc func clickComplaint() {
        if clickComplaintClourse != nil {
            clickComplaintClourse!()
        }
    }

}

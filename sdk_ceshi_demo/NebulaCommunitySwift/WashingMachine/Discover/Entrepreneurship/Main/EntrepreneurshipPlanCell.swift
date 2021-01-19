//
//  EntrepreneurshipPlanCell.swift
//  WashingMachine
//
//  Created by Harious on 2018/2/2.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit
import Kingfisher

class EntrepreneurshipPlanCell: BaseTableViewCell {

    var clickSupportClosures: ((String) -> ())?
    var project: EntrepreneurshipPlan?
    
    @discardableResult
    func config(_ plan: EntrepreneurshipPlan) -> Self  {
        
        project = plan
        
        icon.kf.setImage(with: URL(string: plan.icon ?? ""),
                         placeholder: nil,
                         options: [.transition(ImageTransition.fade(1))])
        titleLabel.text = plan.name
        publisherLabel.text = plan.realName
        schoolLabel.text = plan.schoolName
        lookBtn.setTitle(plan.views?.stringValue ?? "0", for: .normal)
        supportBtn.setTitle(plan.goodCount?.stringValue ?? "0", for: .normal)
        supportBtn.isEnabled = true
        supportBtn.isSelected = plan.isGood?.boolValue ?? false
        
        supportBtn.isEnabled = (plan.publishStatus == .passed)
        
        expertIcon.isHidden = !plan.isExpertComment
        investedIcon.isHidden = !plan.isInvested
        
        return self
    }
    
    func setSupportCount(_ count: Int?) {
        supportBtn.setTitle("\(count ?? 0)", for: .normal)
    }
    
    @objc fileprivate func clickSupport(_ btn: UIButton) {
        
        guard let projectId = project?.id?.stringValue else { return }
        
        btn.isEnabled = false
        clickSupportClosures?(projectId)
    }
    
    override func createUI() {
        super.createUI()
        
        selectionStyle = .none
        contentView.backgroundColor = EntrepreneurshipConfig.backgroundColor
        
        contentView.addSubview(bgView)
        bgView.addSubview(investedIcon)
        bgView.addSubview(icon)
        bgView.addSubview(titleLabel)
        bgView.addSubview(publisherLabel)
        bgView.addSubview(schoolLabel)
        bgView.addSubview(lookBtn)
        bgView.addSubview(supportBtn)
        bgView.addSubview(expertIcon)
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.bottom.right.equalToSuperview()
        }
        icon.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(17)
            make.size.equalTo(CGSize(width: 71, height: 71))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.icon.snp.right).offset(15)
            make.right.equalTo(-15)
            make.top.equalTo(self.icon)
            make.height.lessThanOrEqualTo(45)
        }
        publisherLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.titleLabel)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(5)
            make.height.equalTo(18)
        }
        schoolLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.publisherLabel.snp.bottom).offset(3.5)
            make.left.equalTo(self.titleLabel)
        }
        lookBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel)
            make.top.equalTo(self.schoolLabel.snp.bottom).offset(4)
            make.height.equalTo(20)
        }
        supportBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.lookBtn.snp.right).offset(25)
            make.height.centerY.equalTo(self.lookBtn)
            make.bottom.equalTo(-14)
        }
        expertIcon.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.supportBtn)
            make.right.equalTo(-17)
            make.width.height.equalTo(40)
        }
        investedIcon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(self.expertIcon.snp.left).offset(-10)
            make.width.height.equalTo(90)
        }
    }
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = font_PingFangSC_Regular(15)
        label.textColor = UIColor_0x(0x333333)
        label.numberOfLines = 0
        return label
    }()
    lazy var publisherLabel: UILabel = {
        let label = UILabel()
        label.font = font_PingFangSC_Medium(13)
        label.textColor = UIColor_0x(0x333333)
        return label
    }()
    lazy var schoolLabel: UILabel = {
        let label = UILabel()
        label.font = font_PingFangSC_Regular(12)
        label.textColor = UIColor_0x(0x848484)
        return label
    }()
    lazy var lookBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = font_PingFangSC_Regular(13)
        button.setTitleColor(UIColor_0x(0x979797), for: .normal)
        button.setImage(#imageLiteral(resourceName: "look"), for: .normal)
        button.layout(forEdgeInsetsStyle: .left, imageTitleSpace: 3)
        return button
    }()
    lazy var supportBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = font_PingFangSC_Regular(13)
        button.setTitleColor(UIColor_0x(0x979797), for: .normal)
        button.setImage(#imageLiteral(resourceName: "support"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "support_ed"), for: .selected)
        button.layout(forEdgeInsetsStyle: .left, imageTitleSpace: 3)
        button.addTarget(self, action: #selector(clickSupport(_:)), for: .touchUpInside)
        return button
    }()
    lazy var expertIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "expert_comments")
        return imageView
    }()
    lazy var investedIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "invest_ed")
        return imageView
    }()

}

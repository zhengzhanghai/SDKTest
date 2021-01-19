//
//  EntrepreneurshopPlanSchoolCell.swift
//  WashingMachine
//
//  Created by Harious on 2018/2/5.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit
import Kingfisher

class EntrepreneurshopPlanSchoolCell: BaseTableViewCell {
    
    @discardableResult
    func config(_ schoolRanking: EntrepreneurshipPlanSchoolRanking, indexPath: IndexPath) -> Self {
        switch indexPath.row {
        case 0, 1, 2:
            rankingIcon.isHidden = false
            rankingLabel.isHidden = true
            rankingIcon.image = rankingIcon(indexPath)
        case 3, 4, 5, 6, 7, 8, 9:
            rankingIcon.isHidden = true
            rankingLabel.isHidden = false
            rankingLabel.text = "\(indexPath.row + 1)"
        default:
            rankingIcon.isHidden = true
            rankingLabel.isHidden = true
        }
        
        schoolIcon.kf.setImage(with: URL(string: schoolRanking.schoolLogo ?? ""),
                         placeholder: nil,
                         options: [.transition(ImageTransition.fade(1))])
        schoolNameLabel.text = schoolRanking.schoolName
        projectCountLabel.text = "创业项目：\(schoolRanking.projectCount ?? 0)"
        supportCountLabel.text = "总点赞数：\(schoolRanking.goodCount ?? 0)"
        lookCountLabel.text = "总阅读量：\(schoolRanking.viewsCount ?? 0)"
        commentCountLabel.text = "总评论数：\(schoolRanking.commentCount ?? 0)"
        return self
    }
    
    override func createUI() {
        super.createUI()
        
        selectionStyle = .none
        contentView.backgroundColor = EntrepreneurshipConfig.backgroundColor
        
        contentView.addSubview(bgView)
        bgView.addSubview(rankingIcon)
        bgView.addSubview(rankingLabel)
        bgView.addSubview(schoolIcon)
        bgView.addSubview(schoolNameLabel)
        bgView.addSubview(projectCountLabel)
        bgView.addSubview(supportCountLabel)
        bgView.addSubview(lookCountLabel)
        bgView.addSubview(commentCountLabel)
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(7)
            make.left.bottom.right.equalToSuperview()
        }
        rankingIcon.snp.makeConstraints { (make) in
            make.left.equalTo(3.5)
            make.centerY.equalToSuperview()
            make.width.equalTo(36)
            make.height.equalTo(43)
        }
        rankingLabel.snp.makeConstraints { (make) in
            make.left.equalTo(11)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(22)
        }
        schoolIcon.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(37)
            make.width.height.equalTo(60)
            make.bottom.equalTo(-15)
        }
        projectCountLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.schoolIcon.snp.right).offset(10)
            make.width.equalTo((BOUNDS_WIDTH-132)/2)
        }
        supportCountLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.width.centerY.equalTo(self.projectCountLabel)
        }
        lookCountLabel.snp.makeConstraints { (make) in
            make.left.width.equalTo(self.projectCountLabel)
            make.top.equalTo(self.projectCountLabel.snp.bottom).offset(4)
        }
        commentCountLabel.snp.makeConstraints { (make) in
            make.top.width.equalTo(self.lookCountLabel)
            make.left.equalTo(self.supportCountLabel)
        }
        schoolNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.projectCountLabel)
            make.right.equalTo(-15)
            make.bottom.equalTo(self.projectCountLabel.snp.top).offset(-2.5)
        }
    }
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor_0x(0xffffff)
        return view
    }()
    lazy var rankingIcon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    lazy var rankingLabel: UILabel = {
        let label = UILabel()
        label.font = font_PingFangSC_Semibold(13)
        label.backgroundColor = UIColor_0x(0xdadada)
        label.textColor = UIColor_0x(0xffffff)
        label.layer.cornerRadius = 11
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    lazy var schoolIcon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    lazy var schoolNameLabel: UILabel = {
        let label = UILabel()
        label.font = font_PingFangSC_Regular(15)
        label.textColor = UIColor_0x(0x333333)
        return label
    }()
    lazy var projectCountLabel: UILabel = {
        let label = UILabel()
        label.font = font_PingFangSC_Regular(12)
        label.textColor = UIColor_0x(0x848484)
        return label
    }()
    lazy var supportCountLabel: UILabel = {
        let label = UILabel()
        label.font = font_PingFangSC_Regular(12)
        label.textColor = UIColor_0x(0x848484)
        return label
    }()
    lazy var lookCountLabel: UILabel = {
        let label = UILabel()
        label.font = font_PingFangSC_Regular(12)
        label.textColor = UIColor_0x(0x848484)
        return label
    }()
    lazy var commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = font_PingFangSC_Regular(12)
        label.textColor = UIColor_0x(0x848484)
        return label
    }()
}

extension EntrepreneurshopPlanSchoolCell {
    func rankingIcon(_ indexPath: IndexPath) -> UIImage? {
        switch indexPath.row {
        case 0: return #imageLiteral(resourceName: "gold_medal")
        case 1: return #imageLiteral(resourceName: "silver_medal")
        case 2: return #imageLiteral(resourceName: "copper_medal")
        default: return nil
        }
    }
}

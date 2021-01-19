//
//  NoticeCell.swift
//  WashingMachine
//
//  Created by 张丹丹 on 16/11/2.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

import UIKit

class NoticeCell: UITableViewCell {

    class func createCell(tableView: UITableView, indexPath: IndexPath, isLast: Bool) -> NoticeCell {
        tableView.register(self.classForCoder(), forCellReuseIdentifier: "NoticeCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeCell", for: indexPath) as! NoticeCell
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.adjustCell(isFirst: true, isLast: isLast)
        } else {
            cell.adjustCell(isFirst: false, isLast: isLast)
        }
        return cell
    }
    
    func adjustCell(isFirst: Bool, isLast: Bool) {
        self.topLineView.removeFromSuperview()
        self.bottomLineView.removeFromSuperview()
        if isFirst && isLast {
            return
        }
        if isFirst {
            self.contentView.addSubview(self.bottomLineView)
            self.bottomLineView.snp.makeConstraints({ (make) in
                make.top.equalTo(self.circleView.snp.bottom)
                make.bottom.equalToSuperview()
                make.centerX.equalTo(self.circleView)
                make.width.equalTo(1)
            })
            return
        }
        if isLast {
            self.contentView.addSubview(self.topLineView)
            self.topLineView.snp.makeConstraints({ (make) in
                make.top.equalToSuperview()
                make.bottom.equalTo(self.circleView.snp.top)
                make.centerX.equalTo(self.circleView)
                make.width.equalTo(1)
            })
            return
        }
        
        self.contentView.addSubview(self.bottomLineView)
        self.contentView.addSubview(self.topLineView)
        self.bottomLineView.snp.makeConstraints { (make) in
            make.top.equalTo(self.circleView.snp.bottom)
            make.bottom.equalToSuperview()
            make.centerX.equalTo(self.circleView)
            make.width.equalTo(1)
        }
        self.topLineView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalTo(self.circleView.snp.top)
            make.centerX.equalTo(self.circleView)
            make.width.width.equalTo(1)
        }
        
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func makeNoticeCellWithModel(_ model:NoticeModel , indexPath:IndexPath) {
        let time = timeStringFromTimeStamp(timeStamp: model.createTime?.doubleValue ?? 0)
        timeLabel.text = time
        contentLabel.text = model.content
    }
    
    fileprivate func createUI() {
        self.contentView.backgroundColor = BACKGROUNDCOLOR
        
        self.contentView.addSubview(self.circleView)
        self.contentView.addSubview(self.topLineView)
        self.contentView.addSubview(self.bottomLineView)
        self.contentView.addSubview(self.contentBGView)
        self.contentBGView.addSubview(self.timeLabel)
        self.contentBGView.addSubview(self.contentLabel)
        
        self.contentBGView.snp.makeConstraints { (make) in
            make.left.equalTo(31)
            make.right.equalTo(-16)
            make.top.equalTo(10)
            make.bottom.equalToSuperview()
        }
        self.circleView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentBGView)
            make.left.equalTo(9.5)
            make.width.height.equalTo(12)
        }
        self.topLineView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalTo(self.circleView.snp.top)
            make.centerX.equalTo(self.circleView)
            make.width.equalTo(1)
        }
        self.bottomLineView.snp.makeConstraints { (make) in
            make.top.equalTo(self.circleView.snp.bottom)
            make.bottom.equalToSuperview()
            make.centerX.equalTo(self.circleView)
            make.width.equalTo(1)
        }
        self.timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(19)
            make.top.equalTo(16)
        }
        self.contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.timeLabel.snp.bottom).offset(10.5)
            make.left.equalTo(self.timeLabel)
            make.right.equalTo(-19)
            make.bottom.equalTo(-16)
        }
    }
    
    fileprivate lazy var topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColorRGB(221, 221, 221, 1)
        return view;
    }()
    
    fileprivate lazy var circleView: UIView = {
        let view = UIView()
        view.backgroundColor = BACKGROUNDCOLOR
        view.layer.cornerRadius = 6
        view.layer.borderColor = UIColorRGB(221, 221, 221, 1).cgColor
        view.layer.borderWidth = 1.5
        view.clipsToBounds = true
        return view;
    }()
    
    fileprivate lazy var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColorRGB(221, 221, 221, 1)
        return view;
    }()
    
    fileprivate lazy var contentBGView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        return view;
    }()
    
    fileprivate lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UNDERTINTCOLOR
        return label;
    }()
    
    fileprivate lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = DEEPCOLOR
        label.numberOfLines = 0
        return label;
    }()
    
}

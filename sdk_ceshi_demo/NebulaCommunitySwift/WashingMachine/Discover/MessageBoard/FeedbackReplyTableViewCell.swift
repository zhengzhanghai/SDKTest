//
//  FeedbackReplyTableViewCell.swift
//  WashingMachine
//
//  Created by zzh on 2017/6/20.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit
import Kingfisher

class FeedbackReplyTableViewCell: UITableViewCell {
    
    var likeClourse:((String, IndexPath)->())?
    var commendModel: CommentModel?
    var indexPath: IndexPath!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(_ model: CommentModel) {
        commendModel = model
        userIcon.kf.setImage(with: URL.init(string: model.sendPortrait ?? ""),
                             placeholder: UIImage.init(named: "header_moren"),
                             options: [.transition(ImageTransition.fade(1))])
        userName.text = model.sendAccountName
        publicTime.text = timeStringFromTimeStamp(timeStamp: model.createTime?.doubleValue ?? 0)
        schoolSource.text = model.schoolName
        commit.text = model.content
        likeBtn.isSelected = model.isGood?.boolValue ?? false
    }
    
    class func create(tableView: UITableView, indexPath: IndexPath) -> FeedbackReplyTableViewCell {
        tableView.register(self.classForCoder(), forCellReuseIdentifier: NSStringFromClass(self.classForCoder()))
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(self.classForCoder()), for: indexPath) as! FeedbackReplyTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.indexPath = indexPath
        return cell
    }
    
    func setLikeBtnSelected(_ isLike: Bool) {
        likeBtn.isSelected = isLike
    }
    
    func setLikeEnabled(_ isEnabled: Bool) {
        likeBtn.isUserInteractionEnabled = isEnabled
    }
    
    func setLikeCountText(_ countText: String?) {
        
    }
    
     @objc func clickLike() {
        likeBtn.isUserInteractionEnabled = false
        likeClourse?(commendModel?.id?.stringValue ?? "", indexPath)
    }
    
    fileprivate func makeUI() {
        self.contentView.backgroundColor = UIColor.white
        
        contentView.addSubview(userIcon)
        contentView.addSubview(userName)
        contentView.addSubview(publicTime)
        contentView.addSubview(schoolSource)
        contentView.addSubview(commit)
        contentView.addSubview(likeBtn)
        contentView.addSubview(sepLine)
        
        userIcon.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(20)
            make.width.height.equalTo(40)
        }
        userName.snp.makeConstraints { (make) in
            make.left.equalTo(self.userIcon.snp.right).offset(12)
            make.bottom.equalTo(self.userIcon.snp.centerY)
        }
        publicTime.snp.makeConstraints { (make) in
            make.left.equalTo(self.userName)
            make.top.equalTo(self.userIcon.snp.centerY).offset(3)
        }
        schoolSource.snp.makeConstraints { (make) in
            make.left.equalTo(self.publicTime.snp.right).offset(10);
            make.centerY.equalTo(self.publicTime)
        }
        commit.snp.makeConstraints { (make) in
            make.left.equalTo(self.userName)
            make.right.equalTo(-15)
            make.top.equalTo(self.publicTime.snp.bottom).offset(9)
            make.bottom.equalTo(-20)
        }
        likeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(self.userName)
            make.width.equalTo(17)
            make.height.equalTo(13)
        }
        sepLine.snp.makeConstraints { (make) in
            make.left.equalTo(self.userName)
            make.right.equalToSuperview()
            make.bottom.equalTo(-1)
            make.height.equalTo(0.5)
        }
    }
    
    lazy var userIcon: UIImageView = {
        let icon = UIImageView()
        icon.layer.cornerRadius = 20
        icon.clipsToBounds = true
        return icon
    }()
    lazy var userName: UILabel = {
        let label = UILabel()
        label.textColor = UIColorRGB(51, 51, 51, 1)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    lazy var publicTime: UILabel = {
        let label = UILabel()
        label.textColor = UIColorRGB(197, 197,197, 1)
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    lazy var schoolSource: UILabel = {
        let label = UILabel()
        label.textColor = UIColorRGB(197, 197,197, 1)
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    lazy var commit: UILabel = {
        let label = UILabel()
        label.textColor = UIColorRGB(51, 51, 51, 1)
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    lazy var likeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "support"), for: UIControl.State.normal)
        btn.setImage(#imageLiteral(resourceName: "support_ed"), for: UIControl.State.selected)
        btn.addTarget(self, action: #selector(clickLike), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    lazy var sepLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0xdddddd)
        return view
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    deinit {
        ZZPrint("deinit  " + (NSStringFromClass(self.classForCoder).components(separatedBy: ".").last ?? "nil"))
    }
    
}

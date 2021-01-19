//
//  FeedbackReplyHeaderView.swift
//  WashingMachine
//
//  Created by zzh on 2017/6/20.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit
import Kingfisher

class FeedbackReplyHeaderView: UIView {
    
    var clickLikeClorse: (()->())?
    var imageViews: [UIImageView] = [UIImageView]()
    var clickPhotoClourse: ((Int)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(_ model: CommentModel, _ frame: CGRect) {
        self.init(frame: frame)
        makeUI(model)
        config(model)
    }
    
    fileprivate func config(_ model: CommentModel) {
        userIcon.kf.setImage(with: URL.init(string: model.sendPortrait ?? ""),
                             placeholder: UIImage.init(named: "header_moren"),
                             options: [.transition(ImageTransition.fade(1))])
        userName.text = model.sendAccountName
        publicTime.text = timeStringFromTimeStamp(timeStamp: model.createTime?.doubleValue ?? 0)
        schoolSource.text = model.schoolName
        commit.text = model.content
        like.text = model.goodCount?.stringValue
        reply.text = model.replyCount?.stringValue
        likeBgBtn.isUserInteractionEnabled = true
        likeBtn.isSelected = model.isGood?.boolValue ?? false
    }
    
    func setLikeBtnSelected(_ isLike: Bool) {
        likeBtn.isSelected = isLike
    }
    
    func setLikeEnabled(_ isEnabled: Bool) {
        likeBgBtn.isUserInteractionEnabled = isEnabled
    }
    
    func setLikeCountText(_ countText: String?) {
        like.text = countText
    }
    
    fileprivate func makeUI(_ model: CommentModel) {
        self.backgroundColor = UIColor.white
        
        self.addSubview(userIcon)
        self.addSubview(userName)
        self.addSubview(publicTime)
        self.addSubview(schoolSource)
        self.addSubview(commit)
        self.addSubview(likeBgBtn)
        likeBgBtn.addSubview(like)
        likeBgBtn.addSubview(likeBtn)
        self.addSubview(reply)
        self.addSubview(replyIcon)
        
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
            if model.imageModels == nil || model.imageModels?.count == 0 {
                make.bottom.equalTo(-20)
            }
        }
        likeBgBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.centerY.equalTo(self.userName.snp.centerY).offset(-5)
            make.height.equalTo(20)
        }
        like.snp.makeConstraints { (make) in
            make.right.equalTo(-5)
            make.centerY.equalToSuperview()
        }
        likeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.like.snp.left)
            make.centerY.equalTo(self.like)
            make.width.equalTo(17)
            make.height.equalTo(13)
            make.left.equalTo(5)
        }
        reply.snp.makeConstraints { (make) in
            make.right.equalTo(self.likeBtn.snp.left).offset(-14)
            make.centerY.equalTo(self.like)
        }
        replyIcon.snp.makeConstraints { (make) in
            make.right.equalTo(self.reply.snp.left)
            make.centerY.equalTo(self.like)
            make.width.equalTo(17)
            make.height.equalTo(13)
        }
        
        if model.imageModels != nil && model.imageModels!.count > 0 {
            let pictureW = (BOUNDS_WIDTH-88)/3
            for i in 0 ..< model.imageModels!.count {
                let imageModel = model.imageModels![i]
                let imageView = UIImageView()
                imageView.backgroundColor = UIColor(rgb: 0xf9f9f9)
                imageView.isUserInteractionEnabled = true
                imageView.tag = i
                imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(photoTap(_:))))
                imageView.kf.indicatorType = .activity
                imageView.kf.setImage(with: URL.init(string: imageModel.url ?? ""),
                                      placeholder: nil,
                                      options: [.transition(ImageTransition.fade(1))])
                self.addSubview(imageView)
                imageViews.append(imageView)
                imageView.snp.makeConstraints({ (make) in
                    make.left.equalTo(self.commit.snp.left).offset(CGFloat(i%3)*(pictureW+3))
                    make.top.equalTo(self.commit.snp.bottom).offset(CGFloat(i/3)*(pictureW+3)+10)
                    make.width.equalTo(pictureW)
                    make.height.equalTo(pictureW)
                    if i == model.imageModels!.count - 1 {
                        make.bottom.equalTo(-20)
                    }
                })
            }
        }
        
        let sepLine = UIView()
        sepLine.backgroundColor = UIColor(rgb: 0xdddddd)
        self.addSubview(sepLine)
        sepLine.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.bottom.equalTo(-1)
            make.width.equalTo(BOUNDS_WIDTH)
            make.height.equalTo(1)
        }
    }
    
    @objc func photoTap(_ tap: UITapGestureRecognizer) {
        clickPhotoClourse?(tap.view?.tag ?? 0)
    }
    
    @objc func clickLike() {
        likeBgBtn.isUserInteractionEnabled = false
        clickLikeClorse?()
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
    lazy var likeBgBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(clickLike), for: UIControl.Event.touchUpInside)
        return btn
    }()
    lazy var like: UILabel = {
        let label = UILabel()
        label.textColor = UIColorRGB(182, 194, 203, 1)
        label.font = UIFont.systemFont(ofSize: 11)
        label.isUserInteractionEnabled = false
        return label
    }()
    lazy var likeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "support"), for: UIControl.State.normal)
        btn.setImage(#imageLiteral(resourceName: "support_ed"), for: UIControl.State.selected)
        btn.isUserInteractionEnabled = false
        return btn
    }()
    lazy var reply: UILabel = {
        let label = UILabel()
        label.textColor = UIColorRGB(182, 194, 203, 1)
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    lazy var replyIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "comment")
        return imageView
    }()
}


//
//  MessageBoardCell.swift
//  WashingMachine
//
//  Created by Harious on 2018/3/8.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit
import Kingfisher

typealias TableCellDidSelectedImage = ((Int, MessageBoardCell, CommentModel?)->())

class MessageBoardCell: BaseTableViewCell {
    
    /// 点击支持回调
    var likeClourse:((String, IndexPath)->())?
    /// 点击图片回调
    var clickImageClourse: TableCellDidSelectedImage?
    /// 点击更多回复回调
    var moreReplyClourse: ((String)->())?
    
    var commentModel: CommentModel?
    var imageUrls: [String]?
    
    var imageViewArray: [UIImageView] = [UIImageView]()
    var replyLabelArray: [UILabel] = [UILabel]()
    
    func setLikeBtnSelected(_ isLike: Bool) {
        support.isSelected = isLike
    }
    
    func setLikeEnabled(_ isEnabled: Bool) {
        support.isEnabled = isEnabled
    }
    
    func setLikeCountText(_ countText: String?) {
        support.setTitle(countText ?? "0", for: .normal)
    }
    
    func config(_ model: CommentModel) {
        
        commentModel = model
        
        userIcon.kf.setImage(with: URL.init(string: model.sendPortrait ?? ""),
                             placeholder: UIImage.init(named: "header_moren"),
                             options: [.transition(ImageTransition.fade(1))])
        userName.text = model.sendAccountName
        publicTime.text = model.createTime?.timeStr(dateFormat: "yyyy-MM-dd HH:mm")
        schoolSource.text = model.schoolName
        content.text = model.content
        comment.setTitle(model.replyCount?.stringValue ?? "0", for: .normal)
        support.setTitle(model.goodCount?.stringValue ?? "0", for: .normal)
        support.isSelected = model.isGood?.boolValue ?? false
        
        support.isEnabled = true
        
        comment.sizeToFit()
        support.sizeToFit()
        support.hz_x = comment.frame.maxX + 20
        
        photoView.isHidden = (model.cellImageHeight == 0)
        replyBgView.isHidden = (model.cellReplyHeight == 0)
        
        content.hz_height = commentModel?.cellContentHeight ?? 0
        
        configPhotoView()
        configReplyView()
        
        layoutFrameY()
    }
    
    fileprivate func configPhotoView() {
        
        photoView.hz_height = commentModel?.cellImageHeight ?? 0
        
        guard let imageModels = commentModel?.imageModels, imageModels.count > 0 else {
            photoView.isHidden = true
            return
        }
        
        photoView.isHidden = false
        
        let count = imageModels.count > imageViewArray.count ? imageViewArray.count : imageModels.count
        
        for i in 0 ..<  count {
            let imageView = imageViewArray[i]
            imageView.kf.setImage(with: URL.init(string: imageModels[i].url ?? ""),
                                  placeholder: nil,
                                  options: [.transition(ImageTransition.fade(1))])
            imageView.isHidden = false
        }
        
        for i in count ..< imageViewArray.count {
            imageViewArray[i].isHidden = true
        }
    }
    
    fileprivate func configReplyView() {
        
        replyBgView.hz_height = commentModel?.cellReplyHeight ?? 0
        
        guard let replyModels = commentModel?.replyModels, replyModels.count > 0 else {
            replyBgView.isHidden = true
            return
        }
        
        replyBgView.isHidden = false
        replyBgView.setNeedsDisplay()
        
        let count = replyModels.count > replyLabelArray.count ? replyLabelArray.count : replyModels.count
        
        for i in 0 ..< count {
            
            let label = replyLabelArray[i]
            label.isHidden = false
            
            let model = replyModels[i]
            
            let user = (model.sendAccountName ?? "") + ":"
            let content = model.content ?? ""
            let attstr = NSMutableAttributedString(string: user + content)
            attstr.addAttributes([NSAttributedString.Key.foregroundColor: UIColorRGB(56, 92, 167, 1)],
                                 range: NSMakeRange(0, user.count))
            label.attributedText = attstr
            
            label.hz_height = commentModel?.cellReplyItemHeights[i] ?? 0
        }
        
        for i in count ..< replyLabelArray.count {
            replyLabelArray[i].isHidden = true
        }
        
        moreReplyBtn.isHidden = replyModels.count < 3
    }
    
    /// 设置需要变更的y值
    func layoutFrameY() {
        
        photoView.hz_y = content.frame.maxY
        comment.hz_y = photoView.frame.maxY + 10
        support.hz_y = photoView.frame.maxY + 10
        replyBgView.hz_y = comment.frame.maxY
        
        var temLabel: UILabel!
        for i in 0 ..< replyLabelArray.count {
            
            let label = replyLabelArray[i]
            
            if i != 0 {
                label.hz_y = temLabel.frame.maxY
            }
            
            temLabel = label
        }
        
        moreReplyBtn.hz_y = replyLabelArray.last?.frame.maxY ?? 0
    }
    
    //TODO: ------ ➡️ ----- 点击点赞 ------------------
    @objc func clickLike() {
        support.isEnabled = false
        likeClourse?(commentModel?.id?.stringValue ?? "", indexPath!)
    }
    
    //TODO: ------ ➡️ ----- 点击更多回复 ------------------
    @objc fileprivate func clickMoreReply(_ btn: UIButton) {
        
        ZZPrint("点击更多回复")
        
        guard let commentId = commentModel?.id?.stringValue else { return }
    
        moreReplyClourse?(commentId)
    }
    
    //TODO: ------ ➡️ ----- 点击图片 ------------------
    @objc func tapImageAction(_ tap: UITapGestureRecognizer) {
        
        clickImageClourse?(tap.view?.tag ?? 0, self, commentModel)
        ZZPrint(tap.view?.tag)
    }
    
    //MARK: --------------- 第一次常见UI ------------------
    override func createUI() {
        super.createUI()
        
        self.contentView.backgroundColor = UIColor.white
        self.selectionStyle = .none
        
        contentView.addSubview(userIcon)
        contentView.addSubview(userName)
        contentView.addSubview(publicTime)
        contentView.addSubview(schoolSource)
        contentView.addSubview(content)
        contentView.addSubview(photoView)
        contentView.addSubview(comment)
        contentView.addSubview(support)
        contentView.addSubview(replyBgView)
        
        /// 添加图片的子视图
        let imageWidth: CGFloat = (BOUNDS_WIDTH-82-2*3)/3
        let imageMargin: CGFloat = 3
        for index in 0 ..< 9 {
            let imageX = CGFloat(index%3) * (imageWidth+imageMargin)
            let imageY = 10 + CGFloat(index/3) * (imageWidth+imageMargin)
            let imageView = UIImageView(frame: CGRect(x: imageX, y: imageY, width: imageWidth, height: imageWidth))
            imageView.backgroundColor = UIColor(rgb: 0xf9f9f9)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.tag = index
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapImageAction(_:))))
            photoView.addSubview(imageView)
            
            imageViewArray.append(imageView)
        }
        
        /// 添加回复的子视图
        for i in 0 ..< 3 {
            let label = UILabel(frame: CGRect(x: 11,
                                              y: 15+CGFloat(i)*15,
                                              width: replyBgView.hz_width-22,
                                              height: 15))
            label.numberOfLines = 0
            label.font = font_PingFangSC_Regular(14)
            replyBgView.addSubview(label)
            
            replyLabelArray.append(label)
        }
        
        replyBgView.addSubview(moreReplyBtn)
    }
    
    lazy var userIcon: UIImageView = {
        let icon = UIImageView(frame: CGRect(x: 15, y: 20, width: 40, height: 40));
        icon.setRoundCornerRadius()
        return icon
    }()
    lazy var userName: UILabel = {
        let label = UILabel(frame: CGRect(x: 67, y: 20, width: BOUNDS_WIDTH-190, height: 20))
        label.textColor = UIColor_0x(0x333333)
        label.font = font_PingFangSC_Regular(15)
        return label
    }()
    lazy var publicTime: UILabel = {
        let label = UILabel(frame: CGRect(x: BOUNDS_WIDTH-120, y: 20, width: 110, height: 20))
        label.textColor = UIColor_0x(0x979797)
        label.font = font_PingFangSC_Regular(12)
        label.textAlignment = .right
        return label
    }()
    lazy var schoolSource: UILabel = {
        let label = UILabel(frame: CGRect(x: 67, y: 40, width: BOUNDS_WIDTH-82, height: 20))
        label.textColor = UIColor_0x(0x979797)
        label.font = font_PingFangSC_Regular(12)
        return label
    }()
    lazy var content: UILabel = {
        let label = UILabel(frame: CGRect(x: 67, y: 68, width: BOUNDS_WIDTH-82, height: 20))
        label.textColor = UIColor_0x(0x333333)
        label.font = font_PingFangSC_Regular(15)
        label.numberOfLines = 0
        return label
    }()
    lazy var comment: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 67, y: 88, width: 50, height: 20)
        btn.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        btn.setTitle("0", for: .normal)
        btn.titleLabel?.font = font_PingFangSC_Regular(13)
        btn.setTitleColor(UIColor_0x(0x979797), for: .normal)
        btn.isUserInteractionEnabled = false
        return btn
    }()
    lazy var support: UIButton = { [unowned self] in
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 67, y: 88, width: 50, height: 20)
        btn.setImage(#imageLiteral(resourceName: "support"), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "support_ed"), for: .selected)
        btn.setTitle("0", for: .normal)
        btn.titleLabel?.font = font_PingFangSC_Regular(13)
        btn.setTitleColor(UIColor_0x(0x979797), for: .normal)
        btn.addTarget(self, action: #selector(clickLike), for: .touchUpInside)
        return btn
    }()
    lazy var photoView: UIView = {
        let view = UIView(frame: CGRect(x: 67, y: 108, width: BOUNDS_WIDTH-82, height: 0))
        view.backgroundColor = UIColor.white
        return view
    }()
    lazy var moreReplyBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 11, y: 45, width: 80, height: 30))
        btn.setTitle("更多回复", for: .normal)
        btn.titleLabel?.font = font_PingFangSC_Regular(14)
        btn.setTitleColor(UIColorRGB(56, 92, 167, 1), for: .normal)
        btn.titleLabel?.textAlignment = .left
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(clickMoreReply(_:)), for: .touchUpInside)
        return btn
    }()
    lazy var replyBgView: ReplyBgView = {
        let view = ReplyBgView(frame: CGRect(x: 67,
                                             y: 200,
                                             width: BOUNDS_WIDTH-82,
                                             height: 0),
                               fillColor: UIColorRGB(243, 243, 243, 1))
        return view
    }()

}

// MARK: - 回复带三角的背景视图
extension MessageBoardCell {
    
    class ReplyBgView: UIView {
        
        var fillColor: UIColor
        
        init(frame: CGRect, fillColor: UIColor) {
            self.fillColor = fillColor
            super.init(frame: frame)
            
            self.backgroundColor = UIColor.clear
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func draw(_ rect: CGRect) {
            
            let contextRef = UIGraphicsGetCurrentContext()
            contextRef?.setFillColor(fillColor.cgColor)
            contextRef?.setStrokeColor(UIColor.clear.cgColor)
            
            contextRef?.move(to: CGPoint(x: 0, y: 10))
            contextRef?.addLine(to: CGPoint(x: 7, y: 10))
            contextRef?.addLine(to: CGPoint(x: 17, y: 0))
            contextRef?.addLine(to: CGPoint(x: 27, y: 10))
            contextRef?.addLine(to: CGPoint(x: self.hz_width, y: 10))
            contextRef?.addLine(to: CGPoint(x: self.hz_width, y: self.hz_height))
            contextRef?.addLine(to: CGPoint(x: 0, y: self.hz_height))
            contextRef?.drawPath(using: CGPathDrawingMode.fill)
        }
    }
}





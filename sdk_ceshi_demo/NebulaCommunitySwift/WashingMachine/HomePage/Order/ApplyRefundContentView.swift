//
//  ApplyRefundContentView.swift
//  WashingMachine
//
//  Created by Harious on 2017/11/21.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit
import Photos

public struct HZIndexSction {
    var min: Int
    var max: Int
    init(min: Int, max: Int) {
        self.min = min
        self.max = max
    }
}

/// 图片间的间隙
fileprivate let pictureMargin: CGFloat = 8
/// 图片的宽高
fileprivate let pictureWidth = (BOUNDS_WIDTH-48-4*pictureMargin)/5

class ApplyRefundContentView: UIScrollView, TZImagePickerControllerDelegate {
    
    /// 图片数量
    var imageCountSection: HZIndexSction = HZIndexSction(min: 1, max: 5)
    /// 输入的文字最小数
    var explainWordMinCount: Int = 5
    /// 输入的文字最大数
    var explainWordMaxCount: Int = 50
    /// 图片可选择的最小数
    var imageMinCount: Int = 1
    /// 图片可选择的最大数
    var imageMaxCount: Int = 5
    /// 编辑完成后，点击交回调闭包(数据符合要求才会回调)
    var editFinishClourse: ((String, [UIImage])->())?
    
    var canSendClourse: ((Bool)->())?
    var textView: UITextView!
    var textViewWordCountLabel: UILabel!
    weak var controller: UIViewController?
    var addPictureBtn: UIButton!
    var pictureBtns = [UIButton]()
    var pictureCloseBtns = [UIButton]()
    var imageArray = [UIImage]()
    var assetArray = [PHAsset]()
    
    fileprivate var imageBGView: UIView!
    
    convenience init(viewController: UIViewController, imageSction: HZIndexSction, submitClourse:((String, [UIImage])->())?) {
        self.init()
        self.controller = viewController
        self.editFinishClourse = submitClourse
        self.imageCountSection = imageSction
        
        let imageExplainLabel = UILabel()
        imageExplainLabel.font = font_PingFangSC_Medium(14)
        imageExplainLabel.textColor = UIColor(rgb: 0x333333)
        imageExplainLabel.numberOfLines = 0
        let text0 = "* "
        let text1 = "请上传设备异常照片"
        let text2 = "   (\(imageSction.min)-\(imageSction.max)张)"
        let text = text0 + text1 + text2
        let attStr = NSMutableAttributedString(string: text)
        attStr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xFF7733)], range: (text as NSString).range(of: text0))
        attStr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xAAAAAA),NSAttributedString.Key.font: font_PingFangSC_Regular(12)], range: (text as NSString).range(of: text2))
        imageExplainLabel.attributedText = attStr
        self.addSubview(imageExplainLabel)
        imageExplainLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(24)
            make.width.equalTo(BOUNDS_WIDTH-32)
            make.height.equalTo(20)
        }
        
        imageBGView = UIView()
        self.addSubview(imageBGView)
        imageBGView.snp.makeConstraints { (make) in
            make.left.equalTo(24)
            make.top.equalTo(imageExplainLabel.snp.bottom).offset(16)
            make.width.equalTo(BOUNDS_WIDTH-48)
            make.height.equalTo(pictureWidth)
        }
        
        for i in 0 ..< imageSction.max {
            let addPictureBtn = UIButton(type: .custom)
            addPictureBtn.setImage(UIImage(named: "add_image"), for: .normal)
            addPictureBtn.tag = i
            addPictureBtn.clipsToBounds = true
            addPictureBtn.imageView?.contentMode = .scaleAspectFill
            addPictureBtn.addTarget(self, action: #selector(clickAddPicture(_:)), for: .touchUpInside)
            imageBGView.addSubview(addPictureBtn)
            addPictureBtn.snp.makeConstraints { (make) in
                make.left.equalTo(CGFloat(i)*(pictureWidth+pictureMargin))
                make.top.equalToSuperview()
                make.width.height.equalTo(pictureWidth)
            }
            
            pictureBtns.append(addPictureBtn)
            
            let closeBtn = UIButton(type: .custom)
            closeBtn.tag = i
            closeBtn.isHidden = true
            closeBtn.setImage(UIImage(named: "close_image"), for: .normal)
            closeBtn.addTarget(self, action: #selector(clickDelect(btn:)), for: .touchUpInside)
            addPictureBtn.addSubview(closeBtn)
            closeBtn.snp.makeConstraints({ (make) in
                make.right.top.equalToSuperview()
                make.width.height.equalTo(20)
            })
            
            pictureCloseBtns.append(closeBtn)
        }
        
        let reasonLabel = UILabel()
        reasonLabel.font = font_PingFangSC_Medium(14)
        reasonLabel.numberOfLines = 0
        let reasonText1 = "* "
        let reasonText2 = "退款原因"
        let reasonText = reasonText1 + reasonText2
        let reasonTextAttStr = NSMutableAttributedString(string: reasonText)
        reasonTextAttStr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xFF7733)], range: (reasonText as NSString).range(of: reasonText1))
        reasonLabel.attributedText = reasonTextAttStr
        self.addSubview(reasonLabel)
        reasonLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageBGView.snp.bottom).offset(24)
            make.left.equalTo(imageExplainLabel)
            make.height.equalTo(20)
        }
        
        textView = UITextView()
        textView.font = font_PingFangSC_Regular(12)
        textView.layer.cornerRadius = 8
        textView.backgroundColor = UIColor(rgb: 0xF5F5F5)
        textView.textColor = UIColor(rgb: 0x333333)
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textView.delegate = self
        self.addSubview(textView)
        textView.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(19)
            make.top.equalTo(16)
            make.width.equalToSuperview().offset(-32)
        }
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(24)
            make.top.equalTo(reasonLabel.snp.bottom).offset(8)
            make.width.equalTo(BOUNDS_WIDTH-48)
            make.height.equalTo(120)
        }
        
        textViewWordCountLabel = UILabel()
        textViewWordCountLabel.textAlignment = .right
        textViewWordCountLabel.isUserInteractionEnabled = false
        textViewWordCountLabel.text = "0/\(explainWordMaxCount)"
        textViewWordCountLabel.textColor = UIColor(rgb: 0x999999)
        textViewWordCountLabel.font = font_PingFangSC_Regular(12)
        textView.addSubview(textViewWordCountLabel)
        textViewWordCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(75)
            make.left.equalToSuperview()
            make.width.equalToSuperview().offset(-8)
        }
        
        let commitBtn = UIButton()
        commitBtn.backgroundColor = UIColor(rgb: 0x3399FF)
        commitBtn.setTitle("提交", for: .normal)
        commitBtn.clipsToBounds = true
        commitBtn.layer.cornerRadius = 24
        commitBtn.setTitleColor(UIColor.white, for: .normal)
        commitBtn.titleLabel?.font = font_PingFangSC_Medium(14)
        commitBtn.addTarget(self, action: #selector(clickSubmit(_:)), for: .touchUpInside)
        self.addSubview(commitBtn)
        commitBtn.snp.makeConstraints { (make) in
            make.top.equalTo(textView.snp.bottom).offset(48)
            make.centerX.equalToSuperview()
            make.width.equalTo(280)
            make.height.equalTo(48)
            make.bottom.equalTo(-50)
        }
    }
    
    fileprivate func addNewImage(_ images: [UIImage]?, _ assets:[Any]?) {
        guard let images = images else { return }
        guard let assets = assets else { return }
        
        for i in 0 ..< images.count {
            imageArray.append(images[i])
        }
        for i in 0 ..< assets.count {
            assetArray.append((assets[i] as? PHAsset) ?? PHAsset())
        }
        refreshImagesInterface()
    }
    
    fileprivate func refreshImagesInterface() {
        let imageManager = PHCachingImageManager()
        let size = CGSize(width: pictureWidth*1.7, height: pictureWidth*1.7)
        for i in 0 ..< assetArray.count {
            let asset = assetArray[i]
            imageManager.requestImage(for: asset, targetSize:size , contentMode: .aspectFill, options: nil) { (image, info) in
                guard let image = image else {
                    return
                }
                DispatchQueue.main.async {
                    self.pictureBtns[i].setImage(image, for: .normal)
                    self.pictureCloseBtns[i].isHidden = false
                }
            }
        }
        
        for i in assetArray.count ..< imageMaxCount {
            self.pictureBtns[i].setImage(UIImage(named: "add_image"), for: .normal)
            self.pictureCloseBtns[i].isHidden = true
        }
    }
    
    //TODO: ** 点击图片上的删除按钮
    @objc func clickDelect(btn: UIButton) {
        let index = btn.tag
        imageArray.remove(at: index)
        assetArray.remove(at: index)
        refreshImagesInterface()
    }
 
    //TODO: **  点击添加图片按钮
    @objc fileprivate func clickAddPicture(_ btn: UIButton) {
        guard btn.tag >= assetArray.count else {
            return
        }
        
        windowUserEnabled(false)
        let imagePickerVc = TZImagePickerController(maxImagesCount: imageMaxCount-assetArray.count, delegate: self)
        imagePickerVc?.maxImagesCount = imageMaxCount - assetArray.count
        imagePickerVc?.allowPickingOriginalPhoto = true
        imagePickerVc?.allowPickingGif = false
        imagePickerVc?.isSelectOriginalPhoto = true
        
        //MARK: 选择完图片后回调
        imagePickerVc?.didFinishPickingPhotosHandle = { [weak self] (images, assets, isSelectOriginalPhoto) in
            DispatchQueue.main.async {
                self?.addNewImage(images, assets)
            }
        }
        controller?.present(imagePickerVc!, animated: true, completion: {
            windowUserEnabled(true)
        })
    }

    //TODO: **  点击提交按妞
    @objc fileprivate func clickSubmit(_ btn: UIButton) {
        textView.resignFirstResponder()
        let text = textView.text ?? ""
        ZZPrint(text.count)
        guard text.count >= explainWordMinCount && text.count <= explainWordMaxCount else {
            showError("请输入您的退款原因！(\(explainWordMinCount)-\(explainWordMaxCount)字)", superView: self)
            return
        }
        guard imageArray.count >= imageMinCount && imageArray.count <= imageMaxCount else {
            showError("请上传洗衣机异常照片(\(imageMinCount)-\(imageMaxCount)张)", superView: self)
            return
        }
        // 回调到控制器
        self.editFinishClourse?(text, imageArray)
    }
    
    fileprivate lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = font_PingFangSC_Regular(12)
        label.textColor = UIColorRGB(200, 200, 200, 1)
        label.isUserInteractionEnabled = false
        label.numberOfLines = 0
        label.text = "请详细描述你的退款原因，方便为您完成退款"
        return label
    }()

}

extension ApplyRefundContentView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        textViewWordCountLabel.text = "\(textView.text.count)/\(explainWordMaxCount)"
        if textView.text.isEmpty {
            emptyLabel.isHidden = false
        } else {
            emptyLabel.isHidden = true
        }
    }
}

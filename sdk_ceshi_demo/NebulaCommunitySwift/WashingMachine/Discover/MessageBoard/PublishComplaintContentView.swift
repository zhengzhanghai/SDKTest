//
//  PublishComplaintContentView.swift
//  WashingMachine
//
//  Created by zzh on 2017/6/14.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit
import Photos

fileprivate let numberOfWords = 300

class PublishComplaintContentView: UIView, TZImagePickerControllerDelegate {
    
    fileprivate let pictureWidth = (BOUNDS_WIDTH-30-3*5)/4
    fileprivate let pictureBaseY: CGFloat = 160
    fileprivate var inputWarmLabel: UILabel!
    
    var canSendClourse: ((Bool)->())?
    var textView: UITextView!
    weak var controller: UIViewController?
    var addPictureBtn: UIButton!
    var pictureImageViews = [UIImageView]()
    var imageArray = [UIImage]()
    var assetArray = [PHAsset]()
    
    convenience init?(viewController: UIViewController, frame: CGRect) {
        self.init(frame: frame)
        self.controller = viewController
        createUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func keyBoard(_ isClose: Bool) {
        if isClose {
            textView.resignFirstResponder()
        } else {
            textView.becomeFirstResponder()
        }
    }
    
    func getPublishMessage() -> (String, [UIImage]) {
//        var images = [UIImage]()
//        for image in imageArray {
//            if let imageData = UIImagePNGRepresentation(image) {
//                images.append(UIImage(data: imageData) ?? UIImage())
//            } else if let imaData = UIImageJPEGRepresentation(image, 0.3){
//                images.append(UIImage(data: imaData) ?? UIImage())
//            }
//        }
        keyBoard(true)
        return (textView.text ?? "", imageArray)
    }
    
    fileprivate func addNewImage(_ images: [UIImage]?, _ assets:[Any]?) {
        if images == nil {
            return
        }
        if assets == nil {
            return
        }
        
        for i in 0 ..< images!.count {
            imageArray.append(images![i])
        }
        for i in 0 ..< assets!.count {
            assetArray.append((assets![i] as? PHAsset) ?? PHAsset())
        }
        
        let imageManager = PHCachingImageManager()
        let size = CGSize(width: pictureWidth*1.7, height: pictureWidth*1.7)
        let existPictureCount = pictureImageViews.count
        for i in existPictureCount ..< (existPictureCount+assets!.count) {
            let imageView = UIImageView()
            imageView.contentMode = UIView.ContentMode.scaleAspectFill
            imageView.frame = CGRect(x: 15+CGFloat(i%4)*(5+pictureWidth), y: pictureBaseY+CGFloat(i/4)*(5+pictureWidth), width: pictureWidth, height: pictureWidth)
            self.addSubview(imageView)
            imageView.backgroundColor = UIColor.green
            imageView.clipsToBounds = true
            imageView.isUserInteractionEnabled = true
            pictureImageViews.append(imageView)
            if let asset = assets![i-existPictureCount] as? PHAsset {
                imageManager.requestImage(for: asset, targetSize:size , contentMode: .aspectFill, options: nil) { (image, info) in
                    if image != nil {
                        imageView.image = image
                    }
                }
            }
            
            let closeBtn = UIButton(type: .custom)
            closeBtn.frame = CGRect(x: pictureWidth-20, y: 0, width: 20, height: 20)
            closeBtn.tag = i
            closeBtn.setImage(UIImage(named: "delect_picture"), for: .normal)
            closeBtn.addTarget(self, action: #selector(clickDelect(btn:)), for: .touchUpInside)
            imageView.addSubview(closeBtn)
        }
        adjustAddBtnFrame()
    }
    
    @objc func clickDelect(btn: UIButton) {
        windowUserEnabled(false)
        let index = btn.tag
        let imageView = pictureImageViews[index]
        imageView.removeFromSuperview()
        pictureImageViews.remove(at: index)
        imageArray.remove(at: index)
        assetArray.remove(at: index)
        for i in index ..< pictureImageViews.count {
            let imageView = pictureImageViews[i];
            if let btn = imageView.subviews.first as? UIButton {
                btn.tag = i
            }
            UIView.animate(withDuration: 0.1*TimeInterval(i-index+1), animations: {
                imageView.frame = CGRect(x: 15+CGFloat(i%4)*(5+self.pictureWidth),
                                         y: self.pictureBaseY+CGFloat(i/4)*(5+self.pictureWidth),
                                         width: self.pictureWidth,
                                         height: self.pictureWidth)
            })
        }
        let animationCount = pictureImageViews.count - index + 1
        let btnCount = pictureImageViews.count
        UIView.animate(withDuration: TimeInterval(animationCount)*0.1, animations: {
            self.addPictureBtn.frame = CGRect(x: 15+CGFloat(btnCount%4)*(5+self.pictureWidth),
                                              y: self.pictureBaseY+CGFloat(btnCount/4)*(5+self.pictureWidth),
                                              width: self.pictureWidth,
                                              height: self.pictureWidth)
        }) { (_) in
            windowUserEnabled(true)
        }
    }
    
    fileprivate func adjustAddBtnFrame() {
        let count = pictureImageViews.count
        windowUserEnabled(false)
        UIView.animate(withDuration: 0.15, animations: { 
            self.addPictureBtn.frame = CGRect(x: 15+CGFloat(count%4)*(5+self.pictureWidth),
                                              y: self.pictureBaseY+CGFloat(count/4)*(5+self.pictureWidth),
                                              width: self.pictureWidth,
                                              height: self.pictureWidth)
        }) { (_) in
            windowUserEnabled(true)
        }
    }
    
    @objc fileprivate func clickAddPicture() {
        windowUserEnabled(false)
        let imagePickerVc = TZImagePickerController(maxImagesCount: 9, delegate: self)
        imagePickerVc?.maxImagesCount = 9 - pictureImageViews.count;
        imagePickerVc?.allowPickingOriginalPhoto = true;
        imagePickerVc?.allowPickingGif = false;
        imagePickerVc?.isSelectOriginalPhoto = true;
        imagePickerVc?.didFinishPickingPhotosHandle = { (images, assets, isSelectOriginalPhoto) in
            self.addNewImage(images, assets);
        }
        controller?.present(imagePickerVc!, animated: true, completion: {
            windowUserEnabled(true)
        })
    }
    
    fileprivate func createUI() {
        textView = UITextView()
        textView.frame = CGRect(x: 15, y: 15, width: BOUNDS_WIDTH-30, height: 100)
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = UIColorRGB(51, 51, 51, 1)
        textView.delegate = self
        addSubview(textView);
        textView.addSubview(emptyLabel)
        
        inputWarmLabel = UILabel(frame: CGRect(x: 15, y: textView.frame.maxY+7, width: BOUNDS_WIDTH-30, height: 20))
        inputWarmLabel.font = UIFont.systemFont(ofSize: 13)
        inputWarmLabel.textColor = UIColorRGB(199, 204, 209, 1)
        inputWarmLabel.text = "还可以输入\(numberOfWords)字"
        inputWarmLabel.textAlignment = NSTextAlignment.right
        addSubview(inputWarmLabel)
        
        let sepLine = UIView(frame: CGRect(x: 0, y: inputWarmLabel.frame.maxY+7, width: BOUNDS_WIDTH, height: 0.5))
        sepLine.backgroundColor = UIColorRGB(150, 150, 150, 1)
        addSubview(sepLine)
        
        addPictureBtn = UIButton(type: UIButton.ButtonType.custom)
        addPictureBtn.frame = CGRect(x: 15, y: pictureBaseY, width: pictureWidth, height: pictureWidth);
        addPictureBtn.setImage(UIImage(named: "add_picture_icon"), for: .normal)
        addPictureBtn.titleLabel?.font = UIFont.systemFont(ofSize: 60)
        addPictureBtn.addTarget(self, action: #selector(clickAddPicture), for: .touchUpInside)
        addSubview(addPictureBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 250, height: 35)
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColorRGB(150, 150, 150, 1)
        label.isUserInteractionEnabled = false
        label.text = "  和大家分享你的洗衣心得吧~"
        return label
    }()
}

extension PublishComplaintContentView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count == 0 {
            textView.addSubview(emptyLabel)
        } else {
            emptyLabel.removeFromSuperview()
        }
        if numberOfWords < textView.text.count {
            inputWarmLabel.text = "输入字数太多~"
            inputWarmLabel.textColor = UIColor.red
            canSendClourse?(false)
        } else {
            inputWarmLabel.text = "还可以输入\(numberOfWords-textView.text.count)字"
            inputWarmLabel.textColor = UIColorRGB(199, 204, 209, 1)
            if textView.text.count == 0 {
                canSendClourse?(false)
            } else {
                canSendClourse?(true)
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
}


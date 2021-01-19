//
//  FeedbackReplyView.swift
//  WashingMachine
//
//  Created by zzh on 2017/6/20.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

fileprivate let contentWidth: CGFloat = BOUNDS_WIDTH
fileprivate let contentHeight: CGFloat = 150
fileprivate let wordCount = 300

class FeedbackReplyView: UIView {
    
    var textView: UITextView!
    fileprivate var inputWarmLabel: UILabel!
    fileprivate var sendBtn: UIButton!
    fileprivate var wordAlertLabel: UILabel!
    fileprivate var textViewPlaceholder: String = "有话就说，看对眼就上 "
    fileprivate lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 7, y: 0, width: 250, height: 35)
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColorRGB(150, 150, 150, 1)
        label.isUserInteractionEnabled = false
        label.text = self.textViewPlaceholder
        return label
    }()
    
    var cancelClourse: (()->())?
    var sendClourse: ((String)->())?
    
    init(frame: CGRect, placeholder: String = "有话就说，看对眼就上 ") {
        self.textViewPlaceholder = placeholder
        super.init(frame: frame)
        self.makeUI()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeFromSuperview)))
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.makeUI()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeFromSuperview)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func clickCancel() {
        if cancelClourse != nil {
            cancelClourse!()
        }
    }
    
    @objc func clickSend() {
        textView.resignFirstResponder()
        if sendClourse != nil {
            sendClourse!(textView.text)
        }
    }
    
    fileprivate func makeUI(){
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: BOUNDS_HEIGHT-contentHeight, width: contentWidth, height: contentHeight)
        contentView.backgroundColor = UIColor.white
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: nil, action: nil))
        addSubview(contentView)
        
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.frame = CGRect(x: 5, y: 10, width: 50, height: 30)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cancelBtn.setTitleColor(UIColorRGB(186, 186, 186, 1), for: .normal)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.addTarget(self, action: #selector(clickCancel), for: .touchUpInside)
        contentView.addSubview(cancelBtn)
        
        sendBtn = UIButton(type: .custom)
        sendBtn.frame = CGRect(x: BOUNDS_WIDTH-55, y: 10, width: 50, height: 30)
        sendBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        sendBtn.setTitleColor(UIColorRGB(0, 122, 255, 1), for: .normal)
        sendBtn.setTitleColor(UIColor(rgb: 0xcccccc), for: .disabled)
        sendBtn.isEnabled = false
        sendBtn.setTitle("发送", for: .normal)
        sendBtn.addTarget(self, action: #selector(clickSend), for: .touchUpInside)
        contentView.addSubview(sendBtn)
        
        wordAlertLabel = UILabel()
        wordAlertLabel.frame = CGRect(x: 70, y: 10, width: BOUNDS_WIDTH-140, height: 24)
        wordAlertLabel.textAlignment = .center
        wordAlertLabel.textColor = UIColor.red
        wordAlertLabel.font = UIFont.systemFont(ofSize: 12)
        wordAlertLabel.isHidden = true
        contentView.addSubview(wordAlertLabel);
        
        textView = UITextView()
        textView.frame = CGRect(x: 15, y: 50, width: BOUNDS_WIDTH-30, height: 85)
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = UIColorRGB(51, 51, 51, 1)
        textView.backgroundColor = UIColorRGB(241, 241, 241, 1)
        textView.delegate = self
        textView.becomeFirstResponder()
        contentView.addSubview(textView);
        textView.addSubview(emptyLabel)
    }
    

}

extension FeedbackReplyView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count == 0 {
            sendBtn.isEnabled = false
            textView.addSubview(emptyLabel)
        } else {
            emptyLabel.removeFromSuperview()
            if textView.text.count > wordCount {
                sendBtn.isEnabled = false
                wordAlertLabel.text = "输入内容不能太多~"
                wordAlertLabel.isHidden = false
            } else {
                sendBtn.isEnabled = true
                wordAlertLabel.isHidden = true
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
}

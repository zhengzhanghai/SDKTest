//
//  FeedbackReportView.swift
//  WashingMachine
//
//  Created by zzh on 2017/6/20.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class FeedbackReportView: UIView {
    var commitClourse: (([String], String)->())?
    var cancelClourse: (()->())?
    fileprivate let contentWidth: CGFloat = BOUNDS_WIDTH-20
    fileprivate let contentHeight: CGFloat = 360
    fileprivate let btnTitles = [["1":"违法信息"],
                                 ["2":"色情内容"],
                                 ["3":"言语辱骂"],
                                 ["4":"垃圾广告"],
                                 ["5":"泄漏隐私"],
                                 ["6":"其他"]]
    fileprivate let commitBtnDisableColor = UIColorRGB(227, 144, 68, 1).withAlphaComponent(0.5)
    fileprivate let commitBtnNormalColor = UIColorRGB(227, 144, 68, 1)
    fileprivate var reasonTF: UITextField!
    fileprivate var btnArray = [FeedbackReportViewButton]()
    fileprivate var contentView: UIView!
    fileprivate var commitBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
        makeUI()
    }
    
    @objc func tapAction() {
        if cancelClourse != nil {
            cancelClourse!()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func clickBtn(btn: FeedbackReportViewButton) {
        if !btn.isSelected {
            for button in btnArray {
                button.customSelected = false
            }
            btn.customSelected = true
        } else {
            btn.customSelected = false
        }
        
        checkCommitIsCanUse()
    }
    
    @objc func checkCommitIsCanUse() {
        var isCanCommit = false
        for (i, btn) in btnArray.enumerated() {
            if btn.isSelected  {
                if i != btnArray.count-1 {
                    isCanCommit = true
                    break
                } else if (reasonTF.text != ""){
                    isCanCommit = true
                    print("--------")
                    break
                }
            }
        }
        if isCanCommit {
            commitBtn.isEnabled = true
            commitBtn.backgroundColor = commitBtnNormalColor
        } else {
            commitBtn.isEnabled = false
            commitBtn.backgroundColor = commitBtnDisableColor
        }
    }
    
    @objc func clickCommit() {
        var commitIds = [String]()
        for (i, btn) in btnArray.enumerated() {
            if btn.isSelected {
                commitIds.append(btnTitles[i].keys.first ?? "")
            }
        }
        commitClourse?(commitIds, reasonTF.text ?? "")
    }
    
    func showWithAnimation(_ complete: (()->())?) {
        contentView.hz_y = BOUNDS_HEIGHT
        backgroundColor = UIColor(rgb: 0x000000).withAlphaComponent(0)
        UIView.animate(withDuration: 0.2, animations: { 
            self.contentView.hz_y = BOUNDS_HEIGHT-10-self.contentHeight
            self.backgroundColor = UIColor(rgb: 0x000000).withAlphaComponent(0.5)
        }) { (_) in
            if complete != nil {
                complete!()
            }
        }
    }
    
    func hiddenWithAnimation(_ complete: (()->())?) {
        contentView.hz_y = BOUNDS_HEIGHT-10-self.contentHeight
        backgroundColor = UIColor(rgb: 0x000000).withAlphaComponent(0.5)
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.hz_y = BOUNDS_HEIGHT
            self.backgroundColor = UIColor(rgb: 0x000000).withAlphaComponent(0)
        }) { (_) in
            if complete != nil {
                complete!()
            }
        }
    }
    
    @objc func emptyTapAction() {
        
    }
    
    fileprivate func makeUI() {
        backgroundColor = UIColor(rgb: 0x000000).withAlphaComponent(0)
        
        contentView = UIView()
        contentView.frame = CGRect(x: 10, y: BOUNDS_HEIGHT, width: contentWidth, height: contentHeight)
        contentView.backgroundColor = UIColor(rgb: 0xffffff)
        contentView.layer.cornerRadius = 6
        contentView.clipsToBounds = true
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(emptyTapAction)))
        self.addSubview(contentView)
        
        let reasonLabel = UILabel()
        reasonLabel.frame = CGRect(x: 0, y: 19, width: contentWidth, height: 21)
        reasonLabel.textAlignment = .center
        reasonLabel.textColor = UIColorRGB(51, 51, 51, 1)
        reasonLabel.font = UIFont.systemFont(ofSize: 15)
        reasonLabel.text = "举报原因"
        contentView.addSubview(reasonLabel)
        
        let btnWidth: CGFloat = (contentWidth-50)/2
        let btnHeight: CGFloat = 38
        for i in 0 ..< btnTitles.count {
            let btn = FeedbackReportViewButton()
            btn.frame = CGRect(x: 20+CGFloat(i%2)*(10+btnWidth),
                               y: 50+CGFloat(i/2)*(10+btnHeight),
                               width: btnWidth,
                               height: btnHeight)
            btn.setTitle(btnTitles[i].values.first, for: .normal)
            btn.tag = i
            btn.addTarget(self, action: #selector(clickBtn(btn:)), for: .touchUpInside)
            contentView.addSubview(btn)
            btnArray.append(btn)
        }
        
        let despLabel = UILabel()
        despLabel.frame = CGRect(x: 0, y: 204, width: contentWidth, height: 21)
        despLabel.textAlignment = .center
        despLabel.textColor = UIColorRGB(51, 51, 51, 1)
        despLabel.font = UIFont.systemFont(ofSize: 15)
        despLabel.text = "信息描述"
        contentView.addSubview(despLabel)
        
        reasonTF = UITextField()
        reasonTF.frame = CGRect(x: 20, y: 235, width: contentWidth-40, height: 44)
        reasonTF.backgroundColor = UIColorRGB(220, 220, 220, 1)
        reasonTF.placeholder = "  您可写下对举报内容的描述（选填）"
        reasonTF.font = UIFont.systemFont(ofSize: 14)
        reasonTF.clipsToBounds = true
        reasonTF.layer.cornerRadius = 3
        reasonTF.addTarget(self, action: #selector(checkCommitIsCanUse), for: .editingChanged)
        contentView.addSubview(reasonTF)
        
        commitBtn = UIButton(type: .custom)
        commitBtn.frame = CGRect(x: 20, y: 300, width: contentWidth-40, height: 44)
        commitBtn.backgroundColor = commitBtnDisableColor
        commitBtn.setTitle("提交", for: .normal)
        commitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        commitBtn.layer.cornerRadius = 3
        commitBtn.isEnabled = false
        commitBtn.clipsToBounds = true
        commitBtn.addTarget(self, action: #selector(clickCommit), for: .touchUpInside)
        contentView.addSubview(commitBtn)
    }
    
    deinit {
        print("FeedbackReportView deinit")
    }
}


class FeedbackReportViewButton: UIButton {
    fileprivate let btnBorderNormalColor = UIColorRGB(208, 208, 208, 1).cgColor
    fileprivate let btnBorderSelectoredColor = UIColorRGB(227, 144, 68, 1).cgColor
    fileprivate let btnTextNormalColor = UIColorRGB(51, 51, 51, 1)
    fileprivate let btnTexSelectoredColor = UIColorRGB(224, 126, 17, 1)
    fileprivate let btnBackgroundNormalColor = UIColorRGB(255, 255, 255, 1)
    fileprivate let btnBackgroundSelectoredColor = UIColorRGB(255, 243, 216, 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configData()
    }
    
    var customSelected: Bool {
        set {
            self.isSelected = newValue
            if newValue {
                self.backgroundColor = btnBackgroundSelectoredColor
                self.layer.borderColor = btnBorderSelectoredColor
            } else {
                self.backgroundColor = btnBackgroundNormalColor
                self.layer.borderColor = btnBorderNormalColor
            }
        }
        get {
            return self.isSelected
        }
    }
    
    private func configData() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 3
        self.layer.borderWidth = 0.5
        self.layer.borderColor = btnBorderNormalColor
        self.backgroundColor = btnBackgroundNormalColor
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.setTitleColor(btnTextNormalColor, for: .normal)
        self.setTitleColor(btnTexSelectoredColor, for: .selected)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

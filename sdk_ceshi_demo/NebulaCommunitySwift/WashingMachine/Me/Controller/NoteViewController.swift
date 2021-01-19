//
//  NoteViewController.swift
//  Tracker
//
//  Created by 张丹丹 on 16/9/9.
//  Copyright © 2016年 张丹丹. All rights reserved.
// 个人信息 -- 单选页面集合

import UIKit

class NoteViewController: BaseViewController {
    //用户从上个页面传值
    var isSender:NSNumber?
    var sexIndex: Int = 0
    var getSex:((String) ->())?
    
    fileprivate var mBtn : UIButton?
    fileprivate var fBtn : UIButton?
    var tag : Int?
    
    fileprivate let BaseTag = 7453
    fileprivate var buttonArr : [UIButton] = [UIButton]()
    fileprivate var selectBtns : [UIButton]!
    fileprivate var selectedBtn : UIButton?
    
    var titleStr:String?
    var btnTag :Int?
    var modifyName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        self.navigationItem.title = "性别"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "确定", style: .plain, target: self, action: #selector(makeSure))
        
        if sexIndex == 0 {
            titleStr = "保密";
        } else if sexIndex == 1 {
            titleStr = "男"
        } else if sexIndex == 2 {
            titleStr = "女"
        }
        btnTag = sexIndex
        makeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc fileprivate func makeSure() {
        if titleStr != "" && titleStr != nil {
            saveInfoData(titleStr!)
        }else{
            showError("还未选择", superView: self.view)
        }
    }
    
    fileprivate func makeUI() {
//        let titles = ["保密", "男", "女"]
        let titles = ["男", "女"]
        self.selectBtns = [UIButton]()
        for i in 0 ..< titles.count {
            let button = UIButton(type: UIButton.ButtonType.custom);
            button.frame = CGRect(x: 0, y: CGFloat(i)*66, width: BOUNDS_WIDTH, height: 66);
            button.addTarget(self, action: #selector(chooseSex(btn:)), for: .touchUpInside)
            button.tag = BaseTag + i
            view.addSubview(button);
            buttonArr.append(button);
            
            let MaleLabel = UILabel(frame:CGRect(x: 15,y: 0, width: 60, height: 65))
            MaleLabel.text = titles[i]
            MaleLabel.textColor = THEMEGRAYCOLOR
            MaleLabel.font = UIFont.systemFont(ofSize: 16)
            button.addSubview(MaleLabel)
            
            let btn = UIButton(frame:CGRect(x: BOUNDS_WIDTH-42,y: 17, width: 28, height: 28))
            btn.setImage(UIImage(named:"nickname_nor"), for: UIControl.State())
            btn.setImage(UIImage(named:"nickname_selected"), for: .selected)
            btn.tag = BaseTag + i
            btn.isUserInteractionEnabled = false
//            btn.addTarget(self, action: #selector(chooseSex(btn:)), for: .touchUpInside)
            button.addSubview(btn)
            self.selectBtns.append(btn)
            
            if sexIndex-1 == i {
                btn.isSelected = true
                button.isSelected = true;
                self.selectedBtn = button
            }
            
            let line = UIView(frame:CGRect(x: 15, y: 65,width: BOUNDS_WIDTH-30, height: 1))
            line.backgroundColor = UIColor.init(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1)
            button.addSubview(line)
        }
    }
    
    @objc fileprivate func chooseSex(btn: UIButton) {
        if btn.tag == self.selectedBtn?.tag {
            return
        }
        for i in 0 ..< self.selectBtns.count {
            let button = self.selectBtns[i]
            button.isSelected = false
            
            let btn = self.buttonArr[i]
            btn.isSelected = false
        }
        btn.isSelected = true
        self.selectedBtn = btn
        let btn1 = selectBtns[btn.tag - BaseTag];
        btn1.isSelected = true;
        let index = btn.tag - BaseTag
        if index == 0 {
            titleStr = "男"
        } else if index == 1 {
            titleStr = "女"
        } else if index == 2 {
            titleStr = "女"
        }
        btnTag = index + 1
    }
    
    fileprivate func saveInfoData(_ str:String) {
        self.showWaitingView(nc_appdelegate?.window ?? self.view)
        MeViewModel.modifyUserInfo(getUserId(), "sex", "\(btnTag ?? 1)", { (isSuccess, message) in
            self.hiddenWaitingView()
            if isSuccess {
                let userModel = UserBaseInfoModel.readFromLocal()
                userModel.sex? = NSNumber.init(value: (self.btnTag ?? 1) as Int)
                userModel.writeLocal()
                self.getSex?(self.titleStr ?? "")
                showSucccess("保存成功", superView: appdeleWindow() ?? self.view)
                self.navigationController?.popViewController(animated: true)
            } else {
                showError(message, superView: self.view)
            }
        })
    }
}

//
//  FillNameViewController.swift
//  WashingMachine
//
//  Created by 张丹丹 on 16/10/28.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

import UIKit

class FillNameViewController: BaseViewController,UITextFieldDelegate {
    fileprivate var textField : UITextField?
    //当编辑个人信息时，将之前设置的信息传送过来
    var knownText:String? = ""
    var modifyName:String? = "" //保存修改的关键字
    //将输入的内容带回
    var sendClosure:((String)->())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(saveName))
        
        self.makeUI()
    }

    //点击保存按钮
    @objc fileprivate func saveName() {
        self.textField?.resignFirstResponder()
        if textField?.text == nil || textField?.text == "" {
            showError("请输入昵称", superView: self.view)
            return
        }
        if textField?.text?.isContainsEmoji ?? false {
            showError("昵称中不能包含表情", superView: self.view)
            return
        }
        if (textField?.text?.charactersLength() ?? 0) > 16 {
            showError("昵称最多只能包含16个字符", superView: self.view)
            return
        }
        
        self.showWaitingView(nc_appdelegate?.window ?? self.view)
        let userModel = UserBaseInfoModel.readFromLocal()
        MeViewModel.modifyUserInfo(userModel.id?.stringValue ?? "", modifyName ?? "", textField?.text ?? "") { (isSuccess, message) in
            self.hiddenWaitingView()
            if isSuccess {
                self.sendClosure?(self.textField?.text ?? "")
                if self.modifyName == "accountName" {
                    userModel.accountName = self.textField?.text
                }else if self.modifyName == "nickName" {
                    userModel.nickName = self.textField?.text
                }
                userModel.writeLocal()
                showSucccess("保存成功", superView: appdeleWindow() ?? self.view)
                self.navigationController?.popViewController(animated: true)
            } else {
                showError(message, superView: self.view)
            }
        }
    }
    
    fileprivate func makeUI() {
        
        textField = UITextField(frame: CGRect(x: 10,y: 13, width: BOUNDS_WIDTH-20,height: 50))
        textField?.backgroundColor = UIColor.white
        textField!.placeholder = "请输入..."
        
        textField?.delegate = self
        textField!.borderStyle = .none
        textField?.keyboardType = .default
        textField!.textAlignment = .left //水平左对齐
        textField!.contentVerticalAlignment = .center  //垂直居中对齐
        textField!.clearButtonMode=UITextField.ViewMode.always  //一直显示清除按钮
        
        let userModel = UserBaseInfoModel.readFromLocal()
        textField?.text = userModel.nickName

        view.addSubview(textField!)
        
        
        let line = UIView(frame: CGRect(x: 10,y: 64,width: BOUNDS_WIDTH-20,height: 0.5))
        line.backgroundColor = UIColor_0x(0xcccccc)
        view.addSubview(line)
        if knownText != nil && knownText != "" {
            textField?.text = knownText
        }
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }


}

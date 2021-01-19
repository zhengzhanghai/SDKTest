//
//  RegisterViewController.swift
//  Truck
//
//  Created by 张丹丹 on 16/9/14.
//  Copyright © 2016年 Eteclab. All rights reserved.
// 注册/重置密码

import UIKit
import Kingfisher

class RegisterViewController: BaseViewController,UITextFieldDelegate {
    var type: RegisterType = .register
    fileprivate var authCode:String?
    
    //从登录页面传来的手机号
    internal var mobilePhoneNumber:String?

    @IBOutlet weak var agreeBtn: UIButton!
    @IBOutlet weak var sendButton: SwiftCountdownButton!
    @IBOutlet weak var phoneNumTextField: UITextField!
    @IBOutlet weak var authCodeTextField: UITextField!
    @IBOutlet weak var setPasswordTextField: UITextField!
    @IBOutlet weak var finishBtn: UIButton!
    @IBOutlet weak var userAgreeBtn: UIButton!
    @IBOutlet weak var imageCodeBtn: UIButton!
    @IBOutlet weak var imageCodeTextField: UITextField!
    
    private var imageCodeSessionId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumTextField.delegate = self
        authCodeTextField.delegate = self
        setPasswordTextField.delegate = self
        
        if type == .register {
            self.navigationItem.title = "注册"
            setPasswordTextField.placeholder = "设置密码"
        } else {
            self.navigationItem.title = "忘记密码"
            setPasswordTextField.placeholder = "设置新密码"
        }
        self.finishBtn.layer.cornerRadius = 6
        self.finishBtn.clipsToBounds = true
        self.sendButton.layer.cornerRadius = 6
        self.sendButton.clipsToBounds = true
        agreeBtn.isSelected = true
        
        reloadImageCode()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func reloadImageCode() {
        LoginViewModel.getImageCode { (image, sessionId, message) in
            if let image = image, let sessionId = sessionId {
                self.imageCodeSessionId = sessionId
                self.imageCodeBtn.setImage(image, for: .normal)
            } else {
                showError(message, superView: self.view)
            }
        }
    }
    
    @IBAction func clickAgree(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            finishBtn.isEnabled = true;
            finishBtn.backgroundColor = THEMECOLOR
        } else {
            finishBtn.isEnabled = false;
            finishBtn.backgroundColor = UIColor.lightGray
        }
    }

    @IBAction func clickUserAgree(_ sender: UIButton) {
        let vc = UserAgreeViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClickImageCodeBtn(_ sender: Any) {
        reloadImageCode()
    }
    
    //点击 获取验证码
    @IBAction func getAuthCodeBtn(_ sender: SwiftCountdownButton) {
        view.endEditing(true)
        if !isPhoneNumber(phoneNumTextField.text!) {
            //请输入手机号
            showError("请输入正确的手机号", superView: self.view)
            return
        }
        guard let imageCode = imageCodeTextField.text, imageCode != "" else {
            showError("请输入图形验证码", superView: self.view)
            return
        }
        
        showWaitingView(nc_appdelegate?.window ?? self.view, "获取短信验证码中")
        
        LoginViewModel.sendMobileAuthCode(phoneNumTextField.text ?? "", type, imageCodeTextField.text!, imageCodeSessionId) { (isSuccess, authCode, message) in
            self.hiddenWaitingView()
            if isSuccess {
                sender.maxSecond = 60
                sender.countdown = true
                if let aucodeStr = authCode {
                    self.authCodeTextField.text = aucodeStr
                    showSucccess(message, superView: self.view, afterHidden: 1.3)
                }
            } else {
                showError(message, superView: self.view)
            }
        }
    }
    
    func textFieldShouldReturn(_: UITextField) ->Bool{
        
        phoneNumTextField.resignFirstResponder()
        authCodeTextField.resignFirstResponder()
        setPasswordTextField.resignFirstResponder()
        
        return true
    }
    
    //点击 完成
   
    @IBAction func completeBtn(_ sender: UIButton) {
        phoneNumTextField.resignFirstResponder()
        authCodeTextField.resignFirstResponder()
        setPasswordTextField.resignFirstResponder()

        if !isPhoneNumber(phoneNumTextField.text!) {
            //请输入手机号
            showError("请输入正确的手机号", superView: self.view)
            return
        }
        
        if authCodeTextField.text == "" {
            //请输入验证码
            showError("请输入验证码", superView: self.view)
            return
        }
        if setPasswordTextField.text == "" {
            //请输入验证码
            showError("请输入密码", superView: self.view)
            return
        }
        if setPasswordTextField.text!.count < 6 {
            //请输入验证码
            showError("密码最少六位", superView: self.view)
            return
        }
        
        if type == .register {
            showWaitingView(nc_appdelegate?.window ?? self.view, "注册中")
            LoginViewModel.register(phoneNumTextField.text ?? "", setPasswordTextField.text ?? "", authCodeTextField.text ?? "", compeleteHandler: { (isSuccess, userId, token, message) in
                self.hiddenWaitingView()
                if isSuccess {
                    if userId != nil && token != nil {
                        self.login(userId: userId ?? "", token: token ?? "")
                    } else {
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    showError(message, superView: self.view)
                }
            })
        } else {
            showWaitingView(nc_appdelegate?.window ?? self.view, "重置密码中")
            LoginViewModel.resetPassword(phoneNumTextField.text ?? "", setPasswordTextField.text ?? "", authCodeTextField.text ?? "", compeleteHandler: { (isSuccess, message) in
                self.hiddenWaitingView()
                if isSuccess {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    showError(message, superView: self.view)
                }
            })
         }
    }
    
    func login(userId: String, token: String) {
        showWaitingView(nc_appdelegate?.window ?? self.view, "登录中")
        LoginViewModel.login(phoneNumTextField.text ?? "", setPasswordTextField.text ?? "") { (userModel, message) in
            self.hiddenWaitingView()
            if userModel != nil {
                self.loadInfo()
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    //获取用户资料
    fileprivate func loadInfo() {
        showWaitingView(nc_appdelegate?.window ?? self.view, "正在获取资料")
        let userModel = UserInfoModel.readFromLocal() as? UserInfoModel
        let userId = userModel?.userId?.stringValue ?? ""
        
        MeViewModel.loadUserInfo(userId) { (isNormalVisit , baseInfo, message) in
            self.hiddenWaitingView()
            if let infoModel = baseInfo {
                self.registerJpushId()
                infoModel.writeLocal()
                NotificationCenter.default.post(name: Notification.Name(rawValue: LOGIN_SUCCESS_NOTIFICATION), object: nil)
            } else {
                UserInfoModel.deleteLocal()
            }
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    // 向服务器添加极光推送id
    fileprivate func registerJpushId() {
        if let JPushRegisterId = UserDefaults.standard.value(forKey: JPush_RegistrationID_Key) as? String {
            if JPushRegisterId != "" {
                LoginViewModel.updateJPushRegister(getUserId(), jpushId: JPushRegisterId, nil)
            }
        }
    }
}

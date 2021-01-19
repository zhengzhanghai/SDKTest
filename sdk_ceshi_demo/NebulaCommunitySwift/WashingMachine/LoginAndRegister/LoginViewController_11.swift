//
//  LoginViewController.swift
//  Truck
//
//  Created by 张丹丹 on 16/9/14.
//  Copyright © 2016年 Eteclab. All rights reserved.
//  登录

import UIKit

class LoginViewController_11: BaseViewController {
    
    lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("关闭", for: .normal)
        btn.setTitleColor(UIColor(rgb: 0x333333), for: .normal)
        return btn
    }()
    lazy var titleLabel: UILabel = {
        return UILabel.create(font: font_PingFangSC_Medium(20),
                              textColor: UIColor_0x(0x333333),
                              text: "登录")
    }()
    lazy var phoneNumTextField: UITextField = {
        let textfield = UITextField.create(font: font_PingFangSC_Regular(14),
                                           textColor: .black,
                                           placeholder: "请输入手机号",
                                           placeholderTextColor: UIColor_0x(0xeeeeee),
                                           delegate: self)
        textfield.addBottomLine(color: .lightGray, lineWidth: 0.5)
        return textfield
    }()
    lazy var passwordTextField: UITextField = {
        let textfield = UITextField.create(font: font_PingFangSC_Regular(14),
                                           textColor: .black,
                                           placeholder: "请输入密码",
                                           placeholderTextColor: UIColor_0x(0xeeeeee),
                                           delegate: self,
                                           isSecureTextEntry: true)
        textfield.addBottomLine(color: .lightGray, lineWidth: 0.5)
        textfield.returnKeyType = .go
        return textfield
    }()
    lazy var loginBtn: WMButton = {
        let btn = WMButton(type: .custom)
        btn.setTitle("登录", for: .normal)
        btn.backgroundColor = THEMECOLOR
        btn.disabledBackgroundColor = UIColor(rgb: 0x3399FF)
        btn.titleLabel?.font = font_PingFangSC_Medium(14)
        btn.layer.cornerRadius = 24
        return btn
    }()
    lazy var registerBtn: WMButton = {
        let btn = WMButton(type: .custom)
        btn.setTitle("注册", for: .normal)
        btn.setTitleColor(UIColor(rgb: 0x333333), for: .normal)
        btn.titleLabel?.font = font_PingFangSC_Regular(14)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(rgb: 0xdbdbdb).cgColor
        btn.layer.cornerRadius = 24
        return btn
    }()
    lazy var forgetPasswordLabel: UILabel = {
        let label = UILabel.create(font: font_PingFangSC_Regular(14), text: "忘记密码？")
        label.isUserInteractionEnabled = true
        return label
    }()
    
    //将微信登录成功后获取的值传送给MeViewController
    var passClosures:(() ->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "登录"
        
        setupUI()
        addEvent()
    }
    
    //点击 忘记密码
    @objc fileprivate func forgetPasswordClick() {
        LoginViewModel.pushRegisterVC(.reset, self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //点击   登录
    @IBAction func loginBtn(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        self.logIn()
    }
    
    fileprivate func logIn() {
        
        if phoneNumTextField.text == nil || phoneNumTextField.text == "" {
            showError("手机号不能为空", superView: self.view)
            return
        }
        if passwordTextField.text == nil || passwordTextField.text == "" {
            showError("密码不能为空", superView: self.view)
            return
        }
        if !isPhoneNumber(phoneNumTextField.text!) {
            showError("请输入正确的手机号", superView: self.view)
            return
        }
        
        self.showWaitingView(nc_appdelegate?.window ?? self.view, "登录中")
        LoginViewModel.login(phoneNumTextField.text ?? "", passwordTextField.text ?? "") { (userModel, message) in
            if userModel != nil {
                self.loadInfo()
            } else {
                self.hiddenWaitingView()
                showError(message, superView: self.view)
            }
        }
    }
    
    //获取用户资料
    fileprivate func loadInfo() {
        let userModel = UserInfoModel.readFromLocal()
        let userId = userModel.userId ?? 0
        UserBaseInfoModel.loadUserInfo(userId.stringValue) { (baseInfo, message) in
            self.hiddenWaitingView()
            if baseInfo != nil {
                baseInfo?.writeLocal()
                NotificationCenter.default.post(name: Notification.Name(rawValue: LOGIN_SUCCESS_NOTIFICATION), object: nil)
                self.registerJpushId()
                self.passClosures?()
                UserBalanceManager.share.asynRefreshBalance()
                self.navigationController?.popViewController(animated: true)
            } else {
                showError(message ?? "请求失败", superView: self.view, afterHidden: 2)
            }
        }
    }
    
    @IBAction func registerBtn(_ sender: UIButton) {
        LoginViewModel.pushRegisterVC(.register, self)
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

//MARK: 事件相关
fileprivate extension LoginViewController_11 {
    func addEvent() {
        closeBtn.addTarget(self, action: #selector(onClickCloseBtn), for: .touchUpInside)
        loginBtn.addTarget(self, action: #selector(onCclickLoginBtn), for: .touchUpInside)
        registerBtn.addTarget(self, action: #selector(onClickRegisterBtn), for: .touchUpInside)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onClickForgetPasswordLabel))
        gesture.numberOfTapsRequired = 1
        forgetPasswordLabel.addGestureRecognizer(gesture)
    }
    
    /// 点击关闭按钮
    @objc func onClickCloseBtn() {
        
    }
    
    /// 点击登录按钮
    @objc func onCclickLoginBtn() {
        self.view.endEditing(true)
        
        if phoneNumTextField.text == nil || phoneNumTextField.text == "" {
            showError("手机号不能为空", superView: self.view)
            return
        }
        if passwordTextField.text == nil || passwordTextField.text == "" {
            showError("密码不能为空", superView: self.view)
            return
        }
        if !isPhoneNumber(phoneNumTextField.text!) {
            showError("请输入正确的手机号", superView: self.view)
            return
        }
        
        self.showWaitingView(nc_appdelegate?.window ?? self.view, "登录中")
        LoginViewModel.login(phoneNumTextField.text ?? "", passwordTextField.text ?? "") { (userModel, message) in
            if userModel != nil {
                self.loadInfo()
            } else {
                self.hiddenWaitingView()
                showError(message, superView: self.view)
            }
        }
    }
    
    /// 点击注册按钮
    @objc func onClickRegisterBtn() {
        LoginViewModel.pushRegisterVC(.register, self)
    }
    
    /// 点击忘记密码按钮
    @objc func onClickForgetPasswordLabel() {
        LoginViewModel.pushRegisterVC(.reset, self)
    }
    
}

fileprivate extension LoginViewController_11 {
    func setupUI() {
        view.addSubview(closeBtn)
        view.addSubview(titleLabel)
        view.addSubview(phoneNumTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginBtn)
        view.addSubview(registerBtn)
        view.addSubview(forgetPasswordLabel)
    
        closeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(STATUSBAR_ABSOLUTE_HEIGHT + 5)
            make.right.equalTo(-5)
            make.width.height.equalTo(40)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(STATUSBAR_ABSOLUTE_HEIGHT + 80)
            make.left.equalTo(20)
        }
        phoneNumTextField.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(48)
        }
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(phoneNumTextField.snp.bottom).offset(10)
            make.left.right.height.equalTo(phoneNumTextField)
        }
        forgetPasswordLabel.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.right.equalTo(passwordTextField)
        }
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(48)
        }
        registerBtn.snp.makeConstraints { (make) in
            make.top.equalTo(loginBtn.snp.bottom).offset(10)
            make.left.right.height.equalTo(loginBtn)
        }
    }
}

//MARK: --------------- UITextFieldDelegate ------------------
extension LoginViewController_11: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onCclickLoginBtn()
        return true
    }
}

//
//  LoginViewController.swift
//  Truck
//
//  Created by 张丹丹 on 16/9/14.
//  Copyright © 2016年 Eteclab. All rights reserved.
//  登录
import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var phoneNumTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgetPasswordLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    //将微信登录成功后获取的值传送给MeViewController
    var passClosures:(() ->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "登录"
        
        passwordTextField.delegate = self
        passwordTextField.returnKeyType = .go
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(forgetPasswordClick))
        gesture.numberOfTapsRequired = 1
        forgetPasswordLabel!.isUserInteractionEnabled = true
        forgetPasswordLabel!.addGestureRecognizer(gesture)
        
        loginBtn.layer.cornerRadius = 6
        loginBtn.clipsToBounds = true
        
        registerBtn.layer.borderColor = UIColor(rgb: 0xb4cffc).cgColor
        registerBtn.layer.borderWidth = 1
        registerBtn.layer.cornerRadius = 6
        registerBtn.clipsToBounds = true
        
        passwordTextField.delegate = self
        phoneNumTextField.delegate = self
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
    
 //QQ登录
    @IBAction func oxqLogin(_ sender: UIButton) {
        showError("此功能暂未开通", superView: self.view)
    }
  //微信登录
    @IBAction func wechatLogin(_ sender: UIButton) {
        showError("此功能暂未开通", superView: self.view)
    }
  
    //微博登录
    @IBAction func weiboLogin(_ sender: UIButton) {
        showError("此功能暂未开通", superView: self.view)
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

//MARK: --------------- UITextFieldDelegate ------------------
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        self.logIn()
        
        return true
    }
}

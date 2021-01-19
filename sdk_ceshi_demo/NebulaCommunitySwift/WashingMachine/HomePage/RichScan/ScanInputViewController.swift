//
//  ScanInputViewController.swift
//  WashingMachine
//
//  Created by zzh on 17/3/10.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class ScanInputViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "输入设备编码"
        self.view.backgroundColor = .white
        self.addSub()
    } 

    func addSub() {
        view.addSubview(self.inputTF)
        view.addSubview(self.finishBtn)
        
        self.inputTF.snp.makeConstraints { (make) in
            make.top.equalTo(56)
            make.centerX.equalToSuperview()
            make.width.equalTo(280)
            make.height.equalTo(48)
        }
        self.finishBtn.snp.makeConstraints { (make) in
            make.width.height.centerX.equalTo(self.inputTF)
            make.top.equalTo(self.inputTF.snp.bottom).offset(48)
        }
    }

    //    UIKeyboardTypeASCIICapable
    lazy var inputTF: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor(rgb: 0xF5F5F5)
        textField.clearButtonMode = .whileEditing
        textField.clearButtonRect(forBounds: CGRect(x: 0, y: 0, width: 30, height: 30))
        textField.placeholder = "请输入设备编码"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 1))
        textField.leftViewMode = .always
        textField.returnKeyType = .search
        textField.delegate = self
        textField.textAlignment = .center
        textField.layer.cornerRadius = 24
        textField.keyboardType = UIKeyboardType.asciiCapable
        textField.clipsToBounds = true
        return textField
    }()
    
    lazy var finishBtn: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.backgroundColor = UIColor(rgb: 0x3399FF)
        btn.setTitle("完成", for: UIControl.State.normal)
        btn.titleLabel?.font = font_PingFangSC_Medium(14)
        btn.layer.cornerRadius = 24
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(clickFinish), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        inputTF.becomeFirstResponder()
    }
    
    // 通过IMEI 获取洗衣机详情
    fileprivate func washingDetailWithImei(imei: String) {
        self.showWaitingView(keyWindow)
        DeviceViewModel.loadWasherDetails(imei, getUserId()) { (model, message) in
            
            self.hiddenWaitingView()
            
            guard let device = model else {
                showError(message, superView: self.view)
                return
            }
            
            if device.processPattern == .onewayCommunication {
                // 如果是吹风机
                let vc = UseBlowerViewController(device)
                vc.removeControllerCount = 1
                self.pushViewController(vc)
            } else if device.processPattern == .equipmentCoemmunication {
                
                guard device.isEmpty else {
                    let alertStr = "洗衣机当前" + device.washStatusStr + "，请选择其他空闲设备"
                    self.alertSurePrompt(message: alertStr)
                    return
                }
                
                DeviceViewModel.pushWashingPayVC(device, self, removeVCCount: 1)
            }
            
        }
    }
    
    @objc fileprivate func clickFinish() {
        self.inputTF.resignFirstResponder()
        guard (self.inputTF.text?.isNumberOrAlphabet() ?? false) else {
            showError("请输入正确的设备编码", superView: self.view)
            return
        }
        self.washingDetailWithImei(imei: self.inputTF.text ?? "")
    }


}

extension ScanInputViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let imeiStr = textField.text, !imeiStr.isEmpty else {
            return true
        }
        
        textField.resignFirstResponder()
        
        self.washingDetailWithImei(imei: imeiStr)
        
        return true
    }
}

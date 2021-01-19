//
//  SchoolAccreditationController.swift
//  WashingMachine
//
//  Created by zzh on 2017/5/2.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class SchoolAccreditationController: BaseViewController {
    
    var regionTF: UITextField!
    var schoolTF: UITextField!
    var cityModel: CityModel?
    var schoolModel: SchoolModel?
    
    lazy var chooseView: SchoolAccreditationChooseView = {
        let view = SchoolAccreditationChooseView()
        view.didSelectedItem = { (index, obj) in
            self.didSelectedChooseViewCell(index, obj: obj)
        }
        view.closeClosure = {
            self.onCloseChooseView()
        }
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = BACKGROUNDCOLOR
        self.navigationItem.title = "学校认证"
        self.makeUI()
        self.loadSchoolMessage()
    }
    
    //
    func finishCity(city: CityModel) {
        cityModel = city
        self.regionTF.text = city.name
        self.schoolTF.text = ""
    }
    
    fileprivate func makeUI() {
        let explainLabel = UILabel()
        explainLabel.text = "为了不影响您正常使用洗衣机，请认真选择!"
        explainLabel.textColor = UIColor(rgb: 0x666666)
        explainLabel.font = UIFont.systemFont(ofSize: 14)
        explainLabel.backgroundColor = UIColor(rgb: 0xCCCCCC)
        explainLabel.textAlignment = .center
        explainLabel.numberOfLines = 0
        self.view.addSubview(explainLabel)
        explainLabel.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(20)
        }
        
        let titles = ["地区", "学校"]
        let placeHolders = ["请选择学校所在省市", "请选择学校"]
        let viewHeight: CGFloat = 60
        for i in 0 ..< titles.count {
            let backgroundBtn = UIButton(type: UIButton.ButtonType.custom);
            backgroundBtn.backgroundColor = UIColor.white
            backgroundBtn.tag = i;
            backgroundBtn.addTarget(self, action: #selector(clickBtn(btn:)), for: UIControl.Event.touchUpInside)
            self.view.addSubview(backgroundBtn)
            backgroundBtn.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.top.equalTo(explainLabel.snp.bottom).offset(viewHeight*CGFloat(i))
                make.height.equalTo(viewHeight)
            }
            
            let titleLabel = UILabel()
            titleLabel.textColor = UIColor(rgb: 0x333333);
            titleLabel.text = titles[i];
            titleLabel.font = UIFont.systemFont(ofSize: 16);
            backgroundBtn.addSubview(titleLabel)
            titleLabel.snp.makeConstraints({ (make) in
                make.left.equalToSuperview().offset(16)
                make.centerY.equalToSuperview()
            })
            
            let enterIcon = UIImageView()
            enterIcon.image = UIImage(named: "enter")
            backgroundBtn.addSubview(enterIcon)
            enterIcon.snp.makeConstraints({ (make) in
                make.right.equalToSuperview().offset(-16)
                make.centerY.equalTo(titleLabel.snp.centerY)
                make.width.height.equalTo(20)
            })
            
            let textF = UITextField()
            textF.placeholder = placeHolders[i];
            textF.isUserInteractionEnabled = false
            textF.textAlignment = NSTextAlignment.right
            backgroundBtn.addSubview(textF)
            if i == 0 {
                regionTF = textF
            } else {
                schoolTF = textF
            }
            textF.snp.makeConstraints({ (make) in
                make.right.equalTo(enterIcon.snp.left).offset(5)
                make.centerY.equalTo(titleLabel.snp.centerY)
                make.width.lessThanOrEqualTo(BOUNDS_WIDTH-90)
            })
        }
        
        let sureBtn = UIButton(type: UIButton.ButtonType.custom)
        sureBtn.backgroundColor = THEMECOLOR
        sureBtn.setTitle("确定", for: UIControl.State.normal)
        sureBtn.clipsToBounds = true
        sureBtn.layer.cornerRadius = 6;
        sureBtn.addTarget(self, action: #selector(clickSure), for: UIControl.Event.touchUpInside)
        self.view.addSubview(sureBtn)
        sureBtn.snp.makeConstraints { (make) in
            make.top.equalTo(explainLabel.snp.bottom).offset(CGFloat(titles.count) * viewHeight + 15)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(50)
        }
    }
    
    @objc fileprivate func clickBtn(btn: UIButton) {
        if btn.tag == 0 {
            let vc = ChooseRegionViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.accreditationVC = self
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            if cityModel == nil  {
                showError("请先选择省市", superView: self.view)
                return
            }
            let vc = ChooseSchoolViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.cityId = cityModel?.id
            vc.finishChooseSchoolClourse = { [weak self] school in
                self?.schoolModel = school
                self?.schoolTF.text = school.name
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: 事件相关
fileprivate extension SchoolAccreditationController {
    
    /// 点击选择学校、地区等的cell回调
    func didSelectedChooseViewCell(_ index: Int, obj: SchoolAccreditationModelProtocol) {
        
    }
    
    /// 当关闭选择视图
    func onCloseChooseView() {
        
    }
    
    @objc func clickSure() {
        if schoolModel == nil || schoolTF.text == nil || schoolTF.text == "" {
            showError("请先选择学校", superView: self.view)
            return
        }
        self.showWaitingView(appRootView ?? self.view)
        MeViewModel.modifyUserInfo(getUserId(), "schoolId", schoolModel?.id?.stringValue ?? "") { (isSuccess, message) in
            self.hiddenWaitingView()
            if isSuccess {
                
                /// 修改全局的学校认证消息
                AuthSchool.modifyAndSave(self.schoolModel?.id?.stringValue ?? "", self.schoolModel?.name ?? "")
                
                showSucccess("认证成功", superView: appdeleWindow() ?? self.view)
                self.navigationController?.popViewController(animated: true)
            } else {
                showError(message, superView: self.view)
            }
        }
    }
}


// MARK: 网络相关
fileprivate extension SchoolAccreditationController {
    // 获取认证的学校信息
    func loadSchoolMessage() {
        let url = API_GET_USER_SCHOOL_MESSAGE + getUserId()
        self.showWaitingView(self.view)
        NetworkEngine.get(url, parameters: nil, completionClourse: { (result) in
            self.hiddenWaitingView()
            if result.isSuccess {
                if let dict = result.dataObj as? [String: AnyObject] {
                    if let json = dict["data"] as? [String: AnyObject] {
                        let schoolModel = SchoolModel()
                        if let schoolId = json["schoolId"] as? String {
                            schoolModel.id = NSNumber(value: Int(schoolId) ?? -1)
                        }
                        if let schoolName = json["schoolName"] as? String {
                            schoolModel.name = schoolName
                        }
                        if schoolModel.id != nil && schoolModel.id != 0 && schoolModel.id != -1 && schoolModel.name != nil && schoolModel.name != "" {
                            self.schoolModel = schoolModel;
                            self.schoolTF.text = schoolModel.name
                        }
                        
                        let cityModel = CityModel()
                        if let cityId = json["cityId"] as? String {
                            cityModel.id = NSNumber(value: Int(cityId) ?? -1)
                        }
                        if let cityName = json["cityName"] as? String {
                            cityModel.name = cityName
                        }
                        if cityModel.id != nil && cityModel.id != 0 && cityModel.id != -1 && cityModel.name != nil && cityModel.name != ""{
                            self.cityModel = cityModel;
                            self.regionTF.text = cityModel.name
                        }
                    }
                }
            }
        })
    }
}

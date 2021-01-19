//
//  PersonalInfoTableViewController.swift
//  Truck
//
//  Created by 张丹丹 on 16/9/12.
//  Copyright © 2016年 Eteclab. All rights reserved.
// 个人资料

import UIKit
import Kingfisher

class PersonalInfoTableViewController:BaseViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView:UITableView?
    var getImageClourse:(()->())?
    var getNickNameClourse:(()->())?
    var refreshWinningRecordVC:(()->())?
    var blockClourse:(()->())?
    fileprivate var bigBackV:UIView?
    fileprivate var popView : UIView?
    fileprivate var accessStr : String?
    fileprivate var dateString:String? = ""
    
    fileprivate var accessArr:NSMutableArray?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accessArr = NSMutableArray()
        self.automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.white
        
        self.navigationItem.title = "个人资料"
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: BOUNDS_HEIGHT), style: .plain)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.view.addSubview(self.tableView!)
        
        self.tableView!.register(UINib.init(nibName: "PersonalInfoCell", bundle: nil), forCellReuseIdentifier: "personalInfoCell")
        self.tableView!.register(UINib.init(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "ImageCell")
        let bV = UIView()
        bV.backgroundColor = UIColor.init(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1)
        self.tableView!.tableFooterView = bV
    }
	override func backAction() {
        self.refreshWinningRecordVC?()
        self.getNickNameClourse?()
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userModel = UserBaseInfoModel.readFromLocal()
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell") as! ImageCell
            cell.selectionStyle = .none
            cell.titleLabel.text = "头像"
            cell.imageV.kf.setImage(with: URL(string: userModel.portrait ?? ""),
                                    placeholder: UIImage(named: "header_moren"),
                                    options: [.transition(ImageTransition.fade(1))])
            return cell
        } else if indexPath.row == 1 {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "line2Cell")
            cell.textLabel!.text = "手机号"
            cell.selectionStyle = .none
            cell.textLabel?.textColor = THEMEBLACKCOLOR
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            if userModel.mobile != nil && userModel.mobile != "" {
                cell.detailTextLabel?.text = "\(userModel.mobile ?? "")"
            }
            cell.detailTextLabel?.textColor = UIColor(rgb:0x666666)
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
            cell.detailTextLabel?.textAlignment = NSTextAlignment.right
            return cell
        } else {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "personalInfoCell") as! PersonalInfoCell
            cell.selectionStyle = .none
            switch indexPath.row {
            case 2:
                cell.txtLabel!.text = "昵称"
                if userModel.nickName != nil && userModel.nickName != ""{
                        cell.accessLabel.text  = userModel.nickName ?? ""
                }else {
                    cell.accessLabel.text = "匿名"
                }
            case 3:
                cell.txtLabel!.text = "性别"
                if userModel.sex != nil  {
                    if userModel.sex?.int32Value == 1 {
                      cell.accessLabel.text = "男"
                    }else if userModel.sex?.int32Value == 2{
                        cell.accessLabel.text = "女"
                    }else if userModel.sex?.int32Value == 0{
                        cell.accessLabel.text = "保密"
                    }else{
                        cell.accessLabel.text = "未知"
                    }
                }
            default:
                cell.accessLabel.text = ""
            }
            return cell
        }
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //更换头像
        if indexPath.row == 0 {
           
            popView = UIView()
            popView?.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
            popView!.frame = CGRect(x: 0,y: 0,width: BOUNDS_WIDTH,height: BOUNDS_HEIGHT)
            popView?.backgroundColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 0.5)
            popView?.isUserInteractionEnabled = true
            
            let window = UIApplication.shared.keyWindow
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                
                var frame = self.popView!.frame
                frame.origin.y = CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: 0).maxY
                self.popView!.frame = frame
                
                window?.addSubview(self.popView!)
            })
            
            let Wview = UIView()
            Wview.backgroundColor = UIColor.white
            popView?.addSubview(Wview)
            Wview.snp.makeConstraints({ (make) in
                make.left.bottom.equalToSuperview()
                make.width.equalTo(BOUNDS_WIDTH)
            })
            
            let cancleBtn = UIButton()
            cancleBtn.setTitle("取消", for: UIControl.State())
            cancleBtn.setTitleColor(UIColor.white, for: UIControl.State())
            cancleBtn.backgroundColor =  THEMECOLOR
            cancleBtn.addTarget(self, action: #selector(clickCancle), for: .touchUpInside)
            cancleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            Wview.addSubview(cancleBtn)
            cancleBtn.snp.makeConstraints({ (make) in
                make.left.bottom.equalToSuperview()
                make.width.equalTo(BOUNDS_WIDTH)
                make.height.equalTo(48)
            })
            
            let albumBtn = UIButton()
            albumBtn.setTitle("从手机相册选择", for: UIControl.State())
            albumBtn.setTitleColor(THEMECOLOR, for: UIControl.State())
            albumBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            albumBtn.addTarget(self, action: #selector(chooseImageFromAlbum), for:.touchUpInside)
            Wview.addSubview(albumBtn)
            albumBtn.snp.makeConstraints({ (make) in
                make.left.equalToSuperview()
                make.bottom.equalTo(cancleBtn.snp.top)
                make.width.equalTo(BOUNDS_WIDTH)
                make.height.equalTo(55)
            })
            
            let line = UIView()
            line.backgroundColor = UIColor(rgb: 0xECECEC)
            Wview.addSubview(line)
            line.snp.makeConstraints({ (make) in
                make.left.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-10)
                make.bottom.equalTo(albumBtn.snp.top)
                make.height.equalTo(1)
            })
            
            
            let cameraBtn =  UIButton()
            cameraBtn.setTitle("拍照", for: UIControl.State())
            cameraBtn.setTitleColor(THEMECOLOR, for: UIControl.State())
            cameraBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            cameraBtn.addTarget(self, action: #selector(chooseImageFromCamera), for: .touchUpInside)
            Wview.addSubview(cameraBtn)
            cameraBtn.snp.makeConstraints({ (make) in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(albumBtn.snp.height)
                make.bottom.equalTo(line.snp.top)
            })
        }
        //昵称
        if indexPath.row == 2 {
            if !isLogin() {
                showError("请先登录", superView: self.view)
                return
            }
            let fillNameVC = FillNameViewController()
            fillNameVC.modifyName = "nickName"
            fillNameVC.sendClosure = { str in
                tableView.reloadData()
            }
            fillNameVC.title = "昵称"
            self.navigationController?.pushViewController(fillNameVC, animated: true)
        }
     
        //性别
        if indexPath.row == 3 {
            if !isLogin() {
                showError("请先登录", superView: self.view)
                return
            }
        
            let vc = NoteViewController()
            vc.getSex = { (str:String) in
                tableView.reloadData()
            }
            vc.title = "性别"
            let userModel = UserBaseInfoModel.readFromLocal()
            vc.sexIndex = (userModel.sex?.intValue) ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
  
    @objc fileprivate func chooseImageFromAlbum() {
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.navigationController?.present(imagePicker, animated: true, completion: nil)
        popView?.removeFromSuperview()
    }
    
    @objc fileprivate func chooseImageFromCamera() {
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        self.navigationController?.present(imagePicker, animated: true, completion: nil)
        popView?.removeFromSuperview()
    }
    
    @objc fileprivate func clickCancle() {
        popView?.removeFromSuperview()
    }
}

extension PersonalInfoTableViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        ZZPrint("进入相片选择回调")
//        picker.dismiss(animated: true, completion: nil)
//        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
//            self.showWaitingView(appRootView ?? self.view, "上传头像中")
//            MeViewModel.modifyUserHeadPortrait(getUserId(), image) { (isSuccess, imageUrl, message) in
//                self.hiddenWaitingView()
//                if isSuccess {
//                    let index = IndexPath(row: 0 , section: 0)
//                    let cell  = self.tableView?.cellForRow(at: index) as? ImageCell
//                    cell?.imageV.image = image
//                    let userModel = UserBaseInfoModel.readFromLocal()
//                    userModel.portrait = imageUrl
//                    userModel.writeLocal()
//                    self.getImageClourse?()
//                    showSucccess("头像上传成功", superView: self.view)
//                } else {
//                    showError(message, superView: self.view)
//                }
//            }
//        } else {
//            showError("选择图片失败", superView: self.view)
//        }
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        ZZPrint("进入相片选择回调")
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.showWaitingView(appRootView ?? self.view, "上传头像中")
            MeViewModel.modifyUserHeadPortrait(getUserId(), image) { (isSuccess, imageUrl, message) in
                self.hiddenWaitingView()
                if isSuccess {
                    let index = IndexPath(row: 0 , section: 0)
                    let cell  = self.tableView?.cellForRow(at: index) as? ImageCell
                    cell?.imageV.image = image
                    let userModel = UserBaseInfoModel.readFromLocal()
                    userModel.portrait = imageUrl
                    userModel.writeLocal()
                    self.getImageClourse?()
                    showSucccess("头像上传成功", superView: self.view)
                } else {
                    showError(message, superView: self.view)
                }
            }
        } else {
            showError("选择图片失败", superView: self.view)
        }
    }
}

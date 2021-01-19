//
//  PublishEntrepreneurshipContentView.swift
//  WashingMachine
//
//  Created by Harious on 2018/2/6.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension PublishEntrepreneurshipProjectViewController {
    
    class ContentView: UIView {
        
        let baseInfoTitles = ["项目名称", "真实姓名", "所属院校", "团队人数"]
        
        /// 当前选中的团队(1：1-3人；2：4-8人；3：9-15人；4：15人以上）
        var selectedTeamIndex: Int?
        var selectedId: String?
        
        /// 所属控制器
        weak var controller: UIViewController?
        
        var saveClosures:(()->())?
        var publishClosure:(()->())?
        
        /// 存放从相册选择的图片
        var images: [UIImage] = [UIImage]()
        
        lazy var disposeBag: DisposeBag = {
            return DisposeBag()
        }()
        lazy var scrollView: UIScrollView = {
            return UIScrollView()
        }()
        lazy var imageBGView: UIView = {
            return createView(EntrepreneurshipConfig.backgroundColor)
        }()
        lazy var imageCollectionView: UICollectionView = {
            let flow = UICollectionViewFlowLayout()
            flow.minimumLineSpacing = 6
            flow.minimumInteritemSpacing = 6
            flow.sectionInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
            flow.itemSize = CGSize(width: 80, height: 80)
            flow.scrollDirection = .horizontal
            
            let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow)
            collection.showsVerticalScrollIndicator = false
            collection.showsHorizontalScrollIndicator = false
            collection.delegate = self
            collection.dataSource = self
            collection.backgroundColor = EntrepreneurshipConfig.backgroundColor
            CollectionViewCell.register(toCollectionView: collection)
            AddCollectionViewCell.register(toCollectionView: collection)
            return collection
        }()
        lazy var baseInfoBGView: UIView = {
            return createView(UIColor_0x(0xffffff))
        }()
        lazy var despTitleBGview: UIView = {
            return createView(UIColor.white)
        }()
        lazy var buttonBGview: UIView = {
            return createView(UIColor_0x(0xffffff))
        }()
        lazy var saveBtn: UIButton = {
            return createBtn("保存")
        }()
        lazy var publishBtn: UIButton = {
            return createBtn("发布")
        }()
        lazy var projectNameTF: UITextField = {
            return createTextField("项目名称",
                                   font: font_PingFangSC_Regular(15),
                                   textColor: UIColor_0x(0x4e4e4e))
        }()
        lazy var publisherNameTF: UITextField = {
            return createTextField("真实姓名",
                                   font: font_PingFangSC_Regular(15),
                                   textColor: UIColor_0x(0x4e4e4e))
        }()
        lazy var schoolTF: UITextField = {
            let textfield = createTextField("所属院校",
                                            font: font_PingFangSC_Regular(15),
                                            textColor: UIColor_0x(0x4e4e4e))
            textfield.isUserInteractionEnabled = false
            return textfield

        }()
        lazy var schoolAssistBtn: UIButton = {
            return UIButton(type: .custom)
        }()
        lazy var teamNumberTF: UITextField = {
            let textfield = createTextField("团队人数",
                                            font: font_PingFangSC_Regular(15),
                                            textColor: UIColor_0x(0x4e4e4e))
            textfield.isUserInteractionEnabled = false
            return textfield
        }()
        lazy var teamlAssistBtn: UIButton = {
            return UIButton(type: .custom)
        }()
        lazy var chooseTeamView: ChooseTeamView = {
            let teamView = ChooseTeamView()
            teamView.didSureClosures = { [unowned self] (index, text) in
                self.selectedTeamIndex = index
                self.teamNumberTF.text = text
            }
            teamView.pickerView.selectRow(0, inComponent: 0, animated: true)
            return teamView
        }()
        
        lazy var despTextView: UITextView = {
            let textView = UITextView()
            textView.backgroundColor = UIColor.clear
            textView.textColor = UIColor_0x(0x333333)
            textView.font = font_PingFangSC_Regular(15)
                        
            return textView
        }()
        lazy var despTextViewPlaceHolder: UILabel = {
            return createLabel("来介绍一下你的项目吧......",
                               textColor: UIColor_0x(0xbababa),
                               font: font_PingFangSC_Regular(15))
        }()
        
        init(controller: UIViewController) {
            super.init(frame: CGRect.zero)
            self.controller = controller
            
            self.createUI()
            self.configAuthSchoolData()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        /// 给UI配置相关数据
        func configAuthSchoolData() {
            if AuthSchool.isExist {
                self.selectedId = AuthSchool.id
                schoolTF.text = AuthSchool.isExist ? AuthSchool.name : ""
            }
        }
        
        fileprivate func createUI() {
            
            backgroundColor = UIColor.white
            
            addSubview(scrollView)
            addSubview(buttonBGview)
            scrollView.addSubview(imageBGView)
            scrollView.addSubview(baseInfoBGView)
            scrollView.addSubview(despTitleBGview)
            
            buttonBGview.snp.makeConstraints { (make) in
                make.left.bottom.right.equalToSuperview()
                make.height.equalTo(50)
            }
            scrollView.snp.makeConstraints { (make) in
                make.top.left.right.equalToSuperview()
                make.bottom.equalTo(self.buttonBGview.snp.top)
            }
            imageBGView.snp.makeConstraints { (make) in
                make.top.left.width.equalToSuperview()
            }
            baseInfoBGView.snp.makeConstraints { (make) in
                make.top.equalTo(self.imageBGView.snp.bottom)
                make.left.right.equalTo(self.imageBGView)
            }
            despTitleBGview.snp.makeConstraints { (make) in
                make.top.equalTo(self.baseInfoBGView.snp.bottom)
                make.left.right.equalTo(self.imageBGView)
                
                make.bottom.equalToSuperview()
            }
            
            createImageSubView()
            createBaseInfoSubView()
            createBottomSubview()
            createDespSubView()
            
            rxObserver()
        }
        
        //MARK: --------------- 使用RxSwift对一些控件监听 ------------------
        fileprivate func rxObserver() {
            despTextView.rx.text.subscribe(onNext: { [unowned self] text in
                ZZPrint("despTextViewPlaceHolder  isHidden")
                self.despTextViewPlaceHolder.isHidden = !(text == "")
            }).disposed(by: disposeBag)
        }
        
        /// 创建上面图片相关的视图内容
        fileprivate func createImageSubView() {
            imageBGView.addSubview(imageCollectionView)
            imageCollectionView.snp.makeConstraints { (make) in
                make.top.equalTo(17)
                make.left.right.equalToSuperview()
                make.height.equalTo(80)
            }
            
            let alertLabel = createLabel("温馨提示：可将您的项目介绍以图片的形式进行上传",
                                         textColor: UIColor_0x(0xd0d0d0),
                                         font: font_PingFangSC_Regular(12),
                                         superView: imageBGView)
            alertLabel.numberOfLines = 0
            alertLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.imageCollectionView.snp.bottom).offset(11)
                make.left.equalTo(12)
                make.right.equalTo(-12)
                
                make.bottom.equalTo(-12)
            }
        }
        
        /// 创建中间基础信息视图
        fileprivate func createBaseInfoSubView() {
            
            let itemHeight: CGFloat = 60
            
            var bgView: UIView!
            var textField: UITextField!
            
            for (index, title) in baseInfoTitles.enumerated() {
                
                switch index {
                case 0:
                    bgView = UIView()
                    textField = projectNameTF
                case 1:
                    bgView = UIView()
                    textField = publisherNameTF
                case 2:
                    bgView = schoolAssistBtn
                    textField = schoolTF
                case 3:
                    bgView = teamlAssistBtn
                    textField = teamNumberTF
                default :
                    bgView = UIView()
                    textField = UITextField()
                }
                
                baseInfoBGView.addSubview(bgView)
                bgView.snp.makeConstraints({ (make) in
                    make.top.equalTo(CGFloat(index) * itemHeight)
                    make.left.right.equalToSuperview()
                    make.height.equalTo(itemHeight)
                    
                    if index == baseInfoTitles.count-1 {
                        make.bottom.equalToSuperview()
                    }
                })
                
                let titleLabel = createLabel(title,
                                             textColor: UIColor_0x(0x7f7f7f),
                                             font: font_PingFangSC_Regular(13),
                                             superView: bgView)
                titleLabel.snp.makeConstraints({ (make) in
                    make.left.equalTo(12)
                    make.centerY.equalToSuperview()
                    make.width.equalTo(60)
                })

                bgView.addSubview(textField)
                textField.snp.makeConstraints({ (make) in
                    make.centerY.equalToSuperview()
                    make.left.equalTo(titleLabel.snp.right).offset(10)
                    make.height.equalTo(30)
                    make.right.equalTo((index == 2 || index == 3) ? -33 : -16)
                })
                
                if index == 2 || index == 3 {
                    let enterIcon = UIImageView(image: #imageLiteral(resourceName: "enter"))
                    bgView.addSubview(enterIcon)
                    enterIcon.snp.makeConstraints({ (make) in
                        make.centerY.equalToSuperview()
                        make.right.equalTo(-12)
                        make.width.height.equalTo(20)
                    })
                }
                
                let sepline = createView(UIColor_0x(0xeeeeee))
                bgView.addSubview(sepline)
                sepline.snp.makeConstraints({ (make) in
                    make.left.equalTo(12)
                    make.right.equalTo(-12)
                    make.bottom.equalToSuperview()
                    make.height.equalTo(0.5)
                })
            }
        }
        
        /// 创建底部按钮
        fileprivate func createBottomSubview() {
            
            buttonBGview.addSubview(saveBtn)
            buttonBGview.addSubview(publishBtn)
        
            saveBtn.snp.makeConstraints { (make) in
                make.left.equalTo(self.buttonBGview.snp.right).multipliedBy(0.01)
                make.right.equalTo(self.buttonBGview.snp.right).multipliedBy(0.495)
                make.centerY.equalToSuperview()
                make.height.equalTo(44)
            }
            publishBtn.snp.makeConstraints { (make) in
                make.left.equalTo(self.buttonBGview.snp.right).multipliedBy(0.505)
                make.right.equalTo(self.buttonBGview.snp.right).multipliedBy(0.99)
                make.centerY.equalToSuperview()
                make.height.equalTo(44)
            }
        }
        
        /// 创建描述相关信息
        fileprivate func createDespSubView() {
            let titleLabel = createLabel("   项目介绍", textColor: UIColor_0x(0x7f7f7f), font: font_PingFangSC_Regular(13), superView: despTitleBGview)
            titleLabel.backgroundColor = UIColor_0x(0xf7f7f7)
            titleLabel.snp.makeConstraints { (make) in
                make.left.top.right.equalToSuperview()
                make.height.equalTo(43)
            }
            
            despTitleBGview.addSubview(despTextView)
            despTextView.snp.makeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(7.5)
                make.left.equalTo(12)
                make.right.equalTo(-12)
                make.height.equalTo(100)
                make.bottom.equalTo(-20)
            }
            
            despTextView.addSubview(despTextViewPlaceHolder)
            despTextViewPlaceHolder.snp.makeConstraints { (make) in
                make.top.equalTo(8)
                make.left.equalTo(7)
            }
        }
        
        //TODO: ------ ➡️ ----- 点击保存或者发布按钮 ------------------
        @objc fileprivate func clickBottomBtn(_ btn: UIButton) {
            
        }
    }
}

extension PublishEntrepreneurshipProjectViewController.ContentView {
    func createView(_ backGroundColor: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = backGroundColor
        return view
    }
    
    func createBtn(_ text: String) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = THEMECOLOR
        btn.tag = tag
        btn.setTitle(text, for: .normal)
        btn.titleLabel?.font = font_PingFangSC_Regular(18)
        btn.setTitleColor(UIColor_0x(0xffffff), for: .normal)
        btn.layer.cornerRadius = 6
        btn.clipsToBounds = true
        return btn
    }
}

//MARK: --------------- 图片的 UICollectionViewDelegate UICollectionViewDataSource ------------------
extension PublishEntrepreneurshipProjectViewController.ContentView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            return AddCollectionViewCell.create(collectionView, indexPath)
        } else {
            let cell = CollectionViewCell.create(collectionView, indexPath) as! CollectionViewCell
            cell.imageView.image = images[indexPath.row-1]
            cell.didSelectedDeleteClourse = { [unowned self] in
                
                self.images.remove(at: indexPath.row-1)
                
                collectionView.reloadSections(NSIndexSet(index: 0) as IndexSet)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        ZZPrint(indexPath.row)
        
        guard indexPath.row == 0 else { return }
        
        windowUserEnabled(false)
        
        let imagePickerVc = TZImagePickerController(maxImagesCount: 12-images.count, delegate: self)
        imagePickerVc?.maxImagesCount = 12-images.count
        imagePickerVc?.allowPickingOriginalPhoto = true
        imagePickerVc?.allowPickingGif = false
        imagePickerVc?.isSelectOriginalPhoto = true

        //MARK: 选择完图片后回调
        imagePickerVc?.didFinishPickingPhotosHandle = { [unowned self] (imgs, assets, isSelectOriginalPhoto) in

            guard let ims = imgs else { return }
            for image in ims {
                self.images.append(image)
            }
            
            UIView.performWithoutAnimation {
                self.imageCollectionView.reloadSections(NSIndexSet(index: 0) as IndexSet)
            }
        }
        controller?.present(imagePickerVc!, animated: true, completion: {
            windowUserEnabled(true)
        })
        
    }
}

//MARK: --------------- TZImagePickerControllerDelegate ------------------
extension PublishEntrepreneurshipProjectViewController.ContentView: TZImagePickerControllerDelegate {
}

//MARK: --------------- 图片的 CollectionViewCell 类------------------
extension PublishEntrepreneurshipProjectViewController.ContentView {
    
    class CollectionViewCell: NCCollectionViewCell {
        
        var didSelectedDeleteClourse:(()->())?
        
        override func createContentView() {
            super.createContentView()
            
            rxBinding()
            
            contentView.addSubview(imageView)
            contentView.addSubview(deleteBtn)
            imageView.snp.makeConstraints { (make) in
                make.top.left.bottom.right.equalToSuperview()
            }
            deleteBtn.snp.makeConstraints { (make) in
                make.top.right.equalToSuperview()
                make.width.height.equalTo(30)
            }
        }

        fileprivate func rxBinding() {
            deleteBtn.rx.tap.subscribe(onNext: { [unowned self] in
                self.didSelectedDeleteClourse?()
            }).disposed(by: disposeBag)
        }
        
        lazy var imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            return imageView
        }()
        lazy var deleteBtn: UIButton = {
            let btn = UIButton(type: .custom)
            btn.setImage(#imageLiteral(resourceName: "delect_picture"), for: .normal)
            return btn
        }()
        lazy var disposeBag: DisposeBag = {
            return DisposeBag()
        }()
    }
    
    class AddCollectionViewCell: NCCollectionViewCell {
        override func createContentView() {
            super.createContentView()
            
            contentView.backgroundColor = UIColor.white
            
            contentView.addSubview(imageView)
            contentView.addSubview(despLabel)
            
            imageView.snp.makeConstraints { (make) in
                make.top.equalTo(17)
                make.centerX.equalToSuperview()
                make.width.height.equalTo(32)
            }
            despLabel.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(-14)
            }
        }
        
        lazy var imageView: UIImageView = {
            return UIImageView(image: #imageLiteral(resourceName: "add_image_1"))
        }()
        lazy var despLabel: UILabel = {
            return createLabel("上传图片",
                               textColor: UIColor_0x(0x979797),
                               font: font_PingFangSC_Regular(12))
        }()
    }
}

//MARK: --------------- 选择团队视图类 ------------------
extension PublishEntrepreneurshipProjectViewController.ContentView
{
    class ChooseTeamView: UIView {
        
        /// 当前选中的学校(1：1-3人；2：4-8人；3：9-15人；4：15人以上)
        var didSureClosures: ((Int, String)->())?
        
        let titles = ["1-3人", "4-8人", "9-15人", "15人以上"]
        lazy var disposeBag: DisposeBag = {
            return DisposeBag()
        }()
        lazy var contentView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor_0x(0xffffff)
            return view
        }()
        lazy var pickerView: UIPickerView = {
            let picker = UIPickerView()
            picker.delegate = self
            picker.dataSource = self
            return picker
        }()
        lazy var cancelBtn: UIButton = {
            return createBtn("取消")
        }()
        lazy var sureBtn: UIButton = {
            return createBtn("确定")
        }()
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.backgroundColor = UIColor_0x(0x000000).withAlphaComponent(0)
            
            createUI()

            rxObserVer()
        }
        
        //MARK: --------------- 点击选择团队人数视图上的取消、确定，RxSwift ------------------
        func rxObserVer() {
            cancelBtn.rx.tap.subscribe(onNext: { [unowned self] in
                self.hiddenAndRemoveAndAnimation()
            }).disposed(by: disposeBag)
            sureBtn.rx.tap.subscribe(onNext: { [unowned self] in
                
                let pickerSelectedIndex = self.pickerView.selectedRow(inComponent: 0)
                self.didSureClosures?(pickerSelectedIndex+1, self.titles[pickerSelectedIndex])
                
                self.hiddenAndRemoveAndAnimation()
            }).disposed(by: disposeBag)
        }
        
        func showAndAnimation() {
            UIView.animate(withDuration: 0.4, animations: {
                self.contentView.snp.remakeConstraints({ (make) in
                    make.left.bottom.right.equalToSuperview()
                })
                self.backgroundColor = UIColor_0x(0x000000).withAlphaComponent(0.5)
                self.layoutIfNeeded()
            }) { (_) in
                
            }
        }
        
        func hiddenAndRemoveAndAnimation() {
            UIView.animate(withDuration: 0.3, animations: {
                self.contentView.snp.remakeConstraints({ (make) in
                    make.top.equalTo(self.snp.bottom)
                    make.left.right.equalToSuperview()
                })
                self.backgroundColor = UIColor_0x(0x000000).withAlphaComponent(0)
                self.layoutIfNeeded()
            }) { (_) in
                self.removeFromSuperview()
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        fileprivate func createUI() {
            addSubview(contentView)
            contentView.addSubview(pickerView)
            contentView.addSubview(cancelBtn)
            contentView.addSubview(sureBtn)
            
            contentView.snp.makeConstraints { (make) in
                make.top.equalTo(self.snp.bottom)
                make.left.right.equalToSuperview()
            }
            pickerView.snp.makeConstraints { (make) in
                make.left.bottom.right.equalToSuperview()
                make.height.equalTo(200)
            }
            cancelBtn.snp.makeConstraints { (make) in
                make.left.equalTo(5)
                make.bottom.bottom.equalTo(self.pickerView.snp.top)
                make.width.equalTo(50)
                make.height.equalTo(40)
            }
            sureBtn.snp.makeConstraints { (make) in
                make.right.equalTo(-5)
                make.bottom.size.equalTo(self.cancelBtn)
                make.top.equalToSuperview()
            }
        }
        
    }
}

extension PublishEntrepreneurshipProjectViewController.ContentView.ChooseTeamView {
    func createBtn(_ text: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(text, for: .normal)
        button.setTitleColor(THEMECOLOR, for: .normal)
        return button
    }
}

extension PublishEntrepreneurshipProjectViewController.ContentView.ChooseTeamView: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return titles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return titles[row]
    }
}




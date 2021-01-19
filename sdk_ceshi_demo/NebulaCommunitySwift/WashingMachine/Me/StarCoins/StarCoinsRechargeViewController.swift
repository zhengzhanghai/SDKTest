//
//  StarCoinsRechargeViewController.swift
//  WashingMachine
//
//  Created by Harious on 2018/3/30.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON

class StarCoinsRechargeViewController: BaseViewController {

    var vm: ViewModel!
    
    lazy var contenView: ContentView = {
        ZZPrint(vm)
        let content = ContentView(frame: CGRect.zero, packages: vm.walletPackages)
        content.backgroundColor = BACKGROUNDCOLOR
        return content
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "充值"
        
        vm = ViewModel(vc: self)
        
        vm.loadPackageList()
    }
    
    func setUpUI() {
        self.view.addSubview(contenView)
        contenView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

}

extension StarCoinsRechargeViewController {
    
    class ViewModel {
        
        weak var vc: StarCoinsRechargeViewController?
        var walletPackages: [WalletRechargePackage] = [WalletRechargePackage]()
        
        var vcContentView: StarCoinsRechargeViewController.ContentView? {
            return vc?.contenView
        }
        lazy var disposeBag: DisposeBag = {
            return DisposeBag()
        }()
        
        init(vc: StarCoinsRechargeViewController) {
            self.vc = vc
        }
        
        private func rxBinding() {
            
            guard let vcContentView = vc?.contenView else {
                return
            }
            
            //TODO: ------ ➡️ ----- 点击协议 ------------------
            vcContentView.rechargeProtocolBtn.rx.tap.subscribe(onNext: { [unowned self] in
                
                self.vc?.pushViewController(StarCoinsRechargeProtocolViewController())
            
            }).disposed(by: disposeBag)
            
            for item in vcContentView.rechargeItems {
                item.rx.tap.subscribe(onNext: { [unowned self] in
                    
                    guard let items = self.vc?.contenView.rechargeItems else { return }
                    for item in items {
                        item.isSelected = false
                    }
                    
                    item.isSelected = true
                    
                }).disposed(by: disposeBag)
            }
            
            for item in vcContentView.choosePayWayItems {
                item.rx.tap.subscribe(onNext: { [unowned self] in
                    
                    guard let items = self.vc?.contenView.choosePayWayItems else { return }
                    for item in items {
                        item.isSelected = false
                    }
                    
                    item.isSelected = true
                    
                }).disposed(by: disposeBag)
            }
            
            //TODO: ------ ➡️ ----- 选中同意协议或取消同意 ------------------
            vcContentView.agreeProtocolBtn.rx.tap.subscribe(onNext: { [unowned self] in
                self.vc?.contenView.agreeProtocolBtn.isSelected = !(self.vc?.contenView.agreeProtocolBtn.isSelected ?? true)
            })
            
            //TODO: ------ ➡️ ----- 点击确认支付 ------------------
            vcContentView.surePayBtn.rx.tap.subscribe(onNext: { [unowned self] in
                
                guard let vc = self.vc else { return }
                
                guard vc.contenView.agreeProtocolBtn.isSelected else {
                    showError("请阅读并同意充值协议", superView: vc.view)
                    return
                }
                
                guard let choosePayWayItems = self.vc?.contenView.choosePayWayItems else { return }
                guard let rechargeItems = self.vc?.contenView.rechargeItems else { return }
                
                var choosePaywayIndex = 0
                var rechargeIndex = 0
                
                for item in choosePayWayItems {
                    if item.isSelected {
                        choosePaywayIndex = item.tag
                        break
                    }
                }
                
                for item in rechargeItems {
                    if item.isSelected {
                        rechargeIndex = item.tag
                        break
                    }
                }
                
                ZZPrint("点击确认支付 - \(rechargeIndex) - \(choosePaywayIndex)")
                
                
                
                self.sendRechargeQuest(package: self.walletPackages[rechargeIndex],
                                       userId: getUserId(),
                                       payWay: choosePaywayIndex == 0 ? .alipay : .wx)
                
                
                
            })
        }
        
        func sendRechargeQuest(package: WalletRechargePackage, userId: String, payWay: PayWay) {
            
            guard let vc = self.vc else { return }
            
            vc.showWaitingView(keyWindow)
            
            let parameters = ["packageId": package.id, "userId": userId] as [String: Any]
            NetworkEngine.get(api_get_star_coins_recharge_order, parameters: parameters, completionClourse: { (result) in
                
                guard result.isSuccess else {
                    vc.hiddenWaitingView()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.4, execute: {
                        showError(result.message, superView: vc.view)
                    })
                    return
                }
                
                guard let dataDict = (result.dataObj as? [String: Any])?["data"] as? [String: Any] else {
                    vc.hiddenWaitingView()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.4, execute: {
                        showError("充值下单失败", superView: vc.view)
                    })
                    return
                }
                
                let payMessage = NCPayMessage(appId: dataDict["appId"] as? String ?? "",
                                              orderSn: dataDict["rechargeNo"] as? String ?? "",
                                              amount: (dataDict["price"] as? Int)?.stringValue ?? "0",
                                              channel: payWay == .alipay ? .alipay : .wechat,
                                              subject: "星云社区",
                                              body: "星云社区余额充值")
                
                NCPayManager.nebulaRecharge(payMessage: payMessage, rechargeCallBack: { (payResult) in
                    vc.hiddenWaitingView()
                    switch payResult.type {
                    case .beforeEvokePayApp:
                        ZZPrint("吊起支付前的最后一次回调")
                    case .success:
                        vc.hiddenWaitingView()
                        let rechargeSuccessVC = WalletRechargeSuccessViewController()
                        rechargeSuccessVC.nebulaCoins = Float(package.nebulaCoin)/100
                        rechargeSuccessVC.spendRMB = Float(package.price)/100
                        rechargeSuccessVC.orderNo = dataDict["rechargeNo"] as? String ?? ""
                        vc.pushViewController(rechargeSuccessVC)
                        
                    case .defeated:
                        let alertVC = UIAlertController(title: "支付失败,是否重新支付?", message: nil, preferredStyle: .alert)
                        let sureAction = UIAlertAction(title: "重新支付", style: .default) { _ in
                            self.sendRechargeQuest(package: package, userId: userId, payWay: payWay)
                        }
                        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                        alertVC.addAction(cancelAction)
                        alertVC.addAction(sureAction)
                        vc.present(alertVC, animated: true, completion: nil)
                        
                    default:
                        vc.alertSurePrompt(message: payResult.desp)
                    }
                })

            })

        }
        
        func loadPackageList() {
            let paramters = ["page": 1, "size": 20, "userId": getUserId()] as [String: Any]
            NetworkEngine.get(api_get_recharge_package, parameters: paramters) { (result) in
                if result.isSuccess {
                    
                    guard let dataArr = (result.dataObj as? [String: Any])?["data"] as? [[String: Any]] else { return }
                    
                    var packages = [WalletRechargePackage]()
                    for dataDict in dataArr {
                        guard let model = WalletRechargePackage.create(withDict: dataDict) else { continue }
                        packages.append(model)
                    }
                    
                    guard !packages.isEmpty else { return }

                    self.walletPackages = packages
                    self.vc?.setUpUI()
                    self.rxBinding()
                }
            }
        }
    }
}

extension StarCoinsRechargeViewController {
    
    class ContentView: UIView {
        
        var rechargeItems: [RechargeItem] = [RechargeItem]()
        var choosePayWayItems: [ChoosePayWayItem] = [ChoosePayWayItem]()
        
        lazy var agreeProtocolBtn: UIButton = {
            let btn = UIButton(type: .custom)
            btn.setImage(#imageLiteral(resourceName: "not_selected"), for: .normal)
            btn.setImage(#imageLiteral(resourceName: "selected_blue"), for: .selected)
            return btn
        }()
        lazy var surePayBtn: UIButton = {
            let btn = UIButton(type: .custom)
            btn.backgroundColor = THEMECOLOR
            btn.setTitle("确认支付", for: .normal)
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.titleLabel?.font = font_PingFangSC_Regular(18)
            return btn
        }()
        lazy var rechargeProtocolBtn: UIButton = {
            let btn = UIButton(type: .custom)
            btn.setTitle("同意并接受充值协议", for: .normal)
            btn.setTitleColor(UIColor_0x(0x7f7f7f), for: .normal)
            btn.titleLabel?.font = font_PingFangSC_Regular(11)
            return btn
        }()
        
        init(frame: CGRect, packages: [WalletRechargePackage]) {
            super.init(frame: frame)
            
            setUpUI(packages: packages)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setUpUI(packages: [WalletRechargePackage]) {
            
            let bgView = UIView()
            bgView.backgroundColor = UIColor.white
            self.addSubview(bgView)
            bgView.snp.makeConstraints { (make) in
                make.top.left.right.equalToSuperview()
            }
            
            let itemEdgesMargin: CGFloat = 20
            let middleMargin: CGFloat = 12
            let itemWidth: CGFloat = (BOUNDS_WIDTH - itemEdgesMargin*2 - middleMargin)/2
            let itemHeight: CGFloat = itemWidth*77.5/160
            
            for (i, package) in packages.enumerated() {
                let item = RechargeItem(frame: CGRect.zero, starCoins: Float(package.nebulaCoin)/100, costRMB: package.price/100)
                item.tag = i
                bgView.addSubview(item)
                
                item.snp.makeConstraints({ (make) in
                    make.top.equalTo(itemEdgesMargin + (middleMargin+itemHeight) * (CGFloat(i/2)))
                    make.left.equalTo(itemEdgesMargin + (middleMargin+itemWidth) * (CGFloat(i%2)))
                    make.width.equalTo(itemWidth)
                    make.height.equalTo(itemHeight)
                })
                
                rechargeItems.append(item)
            }
            
            rechargeItems.first?.isSelected = true
            
            let choosePaywayLabel = createLabel("请选择支付方式",
                                               textColor: UIColor_0x(0x4a4a4a),
                                               font: font_PingFangSC_Regular(12),
                                               superView: bgView)
            
            
            choosePaywayLabel.snp.makeConstraints { (make) in
                make.top.equalTo(itemEdgesMargin + (middleMargin+itemHeight) * CGFloat(ceil(Double(packages.count)/2)) + 22)
                make.left.equalTo(20)
            }
            
            let sepline = UIView()
            sepline.backgroundColor = UIColor_0x(0xe3e3e3)
            bgView.addSubview(sepline)
            sepline.snp.makeConstraints { (make) in
                make.top.equalTo(choosePaywayLabel.snp.bottom).offset(13)
                make.left.right.equalToSuperview()
                make.height.equalTo(0.5)
            }
            
//            let choosePaywayImages = [#imageLiteral(resourceName: "binding_wx"), #imageLiteral(resourceName: "binding_alipay")]
//            let chooseOaywayTitles = ["微信支付", "支付宝支付"]
            let choosePaywayImages = [#imageLiteral(resourceName: "binding_alipay"), #imageLiteral(resourceName: "binding_wx")]
            let chooseOaywayTitles = ["支付宝支付", "微信支付"]
            
            for (i, image) in choosePaywayImages.enumerated() {
                
                let item = ChoosePayWayItem(frame: CGRect.zero,
                                            payWayImage: image,
                                            titleStr: chooseOaywayTitles[i],
                                            isRecommend: i == 0)
                item.tag = i
                bgView.addSubview(item)
                item.snp.makeConstraints({ (make) in
                    make.top.equalTo(sepline.snp.bottom).offset(CGFloat(i)*51)
                    make.left.right.equalToSuperview()
                    make.height.equalTo(51)
                    
                    if i == choosePaywayImages.count-1 {
                        make.bottom.equalToSuperview()
                    }
                })
                choosePayWayItems.append(item)
            }
            
            choosePayWayItems.first?.isSelected = true
            
            let concessionStatementLabel = createLabel("充值优惠由星云社区提供，与苹果商店无关",
                                                       textColor: UIColor_0x(0xaaaaaa),
                                                       font: font_PingFangSC_Regular(13),
                                                       superView: self)
            self.addSubview(concessionStatementLabel)
            concessionStatementLabel.snp.makeConstraints { (make) in
                make.top.equalTo(sepline.snp.bottom).offset(CGFloat(choosePaywayImages.count)*51 + 15)
                make.left.equalTo(15)
                make.right.equalTo(-15)
            }
            
            self.addSubview(surePayBtn)
            surePayBtn.snp.makeConstraints { (make) in
                make.left.bottom.right.equalToSuperview()
                make.height.equalTo(51)
            }
            
            let protocolBGView = UIView()
            protocolBGView.backgroundColor = UIColor.white
            self.addSubview(protocolBGView)
            protocolBGView.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.bottom.equalTo(self.surePayBtn.snp.top)
                make.height.equalTo(26)
            }
            
            protocolBGView.addSubview(agreeProtocolBtn)
            agreeProtocolBtn.isSelected = true
            agreeProtocolBtn.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.left.equalTo(10)
                make.width.height.equalTo(26)
            }
            
            protocolBGView.addSubview(rechargeProtocolBtn)
            rechargeProtocolBtn.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.left.equalTo(self.agreeProtocolBtn.snp.right).offset(4)
            }
        }
    }
}

extension StarCoinsRechargeViewController {
    
    class RechargeItem: UIControl {
        var starCoins: Float
        var costRMB: Float
        
        override var isSelected: Bool {
            didSet {
                self.backgroundColor = isSelected ? THEMECOLOR : UIColor.white
                self.starCoinsLabel.textColor = isSelected ? UIColor.white : THEMECOLOR
                self.costRMBLabel.textColor = isSelected ? UIColor.white : UIColor_0x(0x9b9b9b)
            }
        }
        
        lazy var starCoinsLabel: UILabel = {
            return createLabel("",
                               textColor: THEMECOLOR,
                               font: font_PingFangSC_Medium(15),
                               superView: self)
        }()
        lazy var costRMBLabel: UILabel = {
            return createLabel("",
                               textColor: UIColor_0x(0x9b9b9b),
                               font: font_PingFangSC_Regular(12),
                               superView: self)
        }()
        
        init(frame: CGRect, starCoins: Float, costRMB: Float) {
            self.starCoins = starCoins
            self.costRMB = costRMB
            
            super.init(frame: frame)
            
            self.backgroundColor = UIColor.white
            
            self.clipsToBounds = true
            self.layer.cornerRadius = 5
            self.layer.borderWidth = 0.5
            self.layer.borderColor = THEMECOLOR.cgColor
            
            self.starCoinsLabel.text = "\(starCoins > 1 ? Int(starCoins).stringValue : starCoins.string(decimalPlaces: 2))元"
            self.costRMBLabel.text = "¥\(costRMB.string(decimalPlaces: 2))"
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            starCoinsLabel.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(self.snp.centerY)
            }
            costRMBLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.snp.centerY)
                make.centerX.equalToSuperview()
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

extension StarCoinsRechargeViewController {
    
    class ChoosePayWayItem: UIControl {
        
        var payWayImage: UIImage
        var titleStr: String
        private(set) var isRecommend: Bool
        
        override var isSelected: Bool {
            didSet {
                selectImageView.image = isSelected ? #imageLiteral(resourceName: "selected_blue") : #imageLiteral(resourceName: "not_selected")
            }
        }
        
        lazy var payWayImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.setRoundCornerRadius()
            return imageView
        }()
        lazy var titleLabel: UILabel = {
            return createLabel("",
                               textColor: UIColor_0x(0x4a4a4a),
                               font: font_PingFangSC_Regular(12),
                               superView: self)
        }()
        lazy var selectImageView : UIImageView = {
            let imageView = UIImageView()
            return imageView
        }()
        lazy var sepline: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor_0x(0xe3e3e3)
            return view
        }()
        lazy var recommendIcon: UIImageView = {
            return UIImageView(image: #imageLiteral(resourceName: "recommend_use"))
        }()
        
        init(frame: CGRect, payWayImage: UIImage, titleStr: String, isRecommend: Bool = false) {
            self.payWayImage = payWayImage
            self.titleStr = titleStr
            self.isRecommend = isRecommend
            
            super.init(frame: frame)
            
            self.addSubview(payWayImageView)
            self.addSubview(titleLabel)
            self.addSubview(selectImageView)
            self.addSubview(sepline)
            
            self.payWayImageView.image = self.payWayImage
            self.titleLabel.text = self.titleStr
            self.selectImageView.image = #imageLiteral(resourceName: "not_selected")
            
            if isRecommend {
                self.addSubview(recommendIcon)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            payWayImageView.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.left.equalTo(19)
                make.width.height.equalTo(25)
            }
            titleLabel.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.left.equalTo(self.payWayImageView.snp.right).offset(8)
            }
            selectImageView.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.right.equalTo(-18)
                make.width.height.equalTo(24)
            }
            sepline.snp.makeConstraints { (make) in
                make.left.bottom.right.equalToSuperview()
                make.height.equalTo(0.5)
            }
            if isRecommend {
                recommendIcon.snp.makeConstraints({ (make) in
                    make.left.equalTo(self.titleLabel.snp.right).offset(5)
                    make.centerY.equalToSuperview()
                })
            }
        }
    }
}












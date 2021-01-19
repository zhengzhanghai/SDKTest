//
//  HomeDeviceViewController.swift
//  WashingMachine
//
//  Created by Harious on 2018/1/11.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

class HomeDeviceViewController: BaseTableViewController {
    
    var scrollMoveDirectionClourse:((HomeViewController.MenuDirection)->())?
    
    fileprivate var commonDeviceArr: [WashingModel] = [WashingModel]()
    fileprivate var usingDeviceArr: [WashingModel] = [WashingModel]()
    fileprivate var noPayDeviceArr: [WashingModel] = [WashingModel]()
    fileprivate var noStartDevicenArr: [WashingModel] = [WashingModel]()
    
    /// 使用中如果设备是空闲状态，存储倒计时时间
    fileprivate var usingCountDownDict : [String : Int] = [String : Int]()
    /// 使用中如果设备是空闲状态，存储倒计时时间
    fileprivate var startFailArr : [String] = [String]()
    
    lazy var countDownTimer: Timer = {
        let timer = Timer(fireAt: Date.distantFuture,
                          interval: 1,
                          target: self,
                          selector: #selector(timerAction),
                          userInfo: nil,
                          repeats: true)
        RunLoop.current.add(timer, forMode: .common)
        return timer
    }()
    
    ///之行广告平台广告视图
    fileprivate lazy var bannerADSView: BannerADSView = {
        let view = BannerADSView()
        return view
    }()
    
    fileprivate var dataSourceArr: [[WashingModel]] {
        return [noPayDeviceArr,
                noStartDevicenArr,
                usingDeviceArr,
                commonDeviceArr]
    }
    
    fileprivate var dataSourceIsEmpty: Bool {
        return noPayDeviceArr.isEmpty
            && noStartDevicenArr.isEmpty
            && usingDeviceArr.isEmpty
            && commonDeviceArr.isEmpty
    }
    
    fileprivate let tableHeaderTitleArr = ["待支付",
                                           "预约订单",
                                           "正在洗衣",
                                           "常用设备"]
    
    fileprivate lazy var emtpyDataView: HomeNoDeviceDataView = {
        let view = HomeNoDeviceDataView()
        view.isHidden = true
        return view
    }()
    
    @objc fileprivate func timerAction() {
        
        /// 是否有新的倒计时结束订单
        var isContainsNewEndCountDown : Bool = false
        
        for (key, value) in usingCountDownDict {
            
            if value <= 1 {
                usingCountDownDict[key] = 0
                
                if startFailArr.contains(key) {
                    
                } else {
                    startFailArr.append(key)
                    isContainsNewEndCountDown = true
                }
                
            } else {
                usingCountDownDict[key] = value - 1
            }
        }
        
        if isContainsNewEndCountDown {
            self.loadUsingDeviceList()
        }
        
    }
    
    override func didMove(toParent parent: UIViewController?) {
        if parent == nil {
            self.countDownTimer.invalidate()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refresh()
    }
    
    /// 刷新本页信息
    func refresh() {
        if isLogin() {
            
            self.loadNoPayDeviceList()
            self.loadNoStartDeviceList()
            self.loadUsingDeviceList()
            self.loadCommonDeviceList()
            
        } else {
            
            self.endRefreshOrLoadMore()
            
            commonDeviceArr.removeAll()
            usingDeviceArr.removeAll()
            noPayDeviceArr.removeAll()
            noStartDevicenArr.removeAll()
            
            emtpyDataView.isHidden = !dataSourceIsEmpty
            self.tableView.reloadData()
        }
    }
    
    //MARK: --------------- viewDidLoad ------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(rgb: 0xfafafa)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 20))
        
        emtpyDataView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoLogin)))
        tableView.addSubview(emtpyDataView)
        emtpyDataView.snp.makeConstraints { (make) in
            make.top.equalTo(56)
            make.left.width.equalToSuperview()
        }
        
        CommonEquipmentEmptyCell.register(toTabeView: tableView)
        CommonEquipmentDisabledCell.register(toTabeView: tableView)
        HomeDeviceUsingCell.register(toTabeView: tableView)
        DeviceEmptyScanCell.register(toTabeView: tableView)
        
        self.configPullDownRefreshHeader { [unowned self] in
            self.refresh()
        }
        
        // 后台进入前台的通知
        addNoticationObserver(self, #selector(applicationDidBecomeActive), UIApplication.didBecomeActiveNotification, nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadAndShowCurrentPageADS()
        
    }
    
    @objc private func gotoLogin() {
        LoginViewModel.pushLoginController(self)
    }
    
    //TODO: ------ ➡️ ----- 从后台进入前台会调用 ------------------
    @objc func applicationDidBecomeActive() {
        ZZPrint("从后台进入前台, 调用了\(NSStringFromClass(self.classForCoder)) 中的方法")
        self.refresh()
    }
    
    //MARK: --------------- 拨打电话 ------------------
    /// 拨打电话
    fileprivate func callTelephone(_ phoneNumber: String?) {
        guard let phoneNumber = phoneNumber else {
            showError("电话号码有误", superView: self.view)
            return
        }
        let teleStr = "tel:\(phoneNumber)"
        guard let teleUlr = URL(string: teleStr) else {
            showError("电话号码有误", superView: self.view)
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(teleUlr, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(teleUlr)
        }
    }
}

//MARK: 通知相关

extension HomeDeviceViewController {
    fileprivate func addNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onLoginAction),
                                               name: Notification.Name(rawValue: LOGIN_SUCCESS_NOTIFICATION),
                                               object: nil)
    }
    
    @objc fileprivate func onLoginAction() {
        
    }
}


//MARK: --------------- tableview的一些代理方法 ------------------
extension HomeDeviceViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSourceArr.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArr[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let device = dataSourceArr[indexPath.section][indexPath.row]
        
        return HomeDeviceCellFactory.create(tableView,
                                            indexPath,
                                            device,
                                            usingCountDownDict,
                                            { [unowned self] (action) in
            switch action {
            case .use: ZZPrint("立即使用")
            case .pay: ZZPrint("前去支付")
            case .start: ZZPrint("开启洗衣机")
            case .contactTheMerchant: self.callTelephone(device.vendorMobile)
            }
            ZZPrint(indexPath.row)
        })
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard isLogin() else {
            LoginViewModel.pushLoginController(self)
            return
        }
        
        switch indexPath.section {
            
        case 0, 1, 2:
            
            let device = dataSourceArr[indexPath.section][indexPath.row]
            guard let deviceId = device.id?.stringValue else {
                showError("没有查询到设备", superView: self.view)
                return
            }
            self.queryOrder(productId: deviceId)
            
        case 3:

            let device = dataSourceArr[indexPath.section][indexPath.row]
            if device.processPattern == .onewayCommunication {
                // 如果是单向通讯设备
                let vc = UseBlowerViewController(device)
                self.pushViewController(vc)
            } else if device.processPattern == .equipmentCoemmunication {
                //  如果是双向通讯设备
                guard let deviceId = device.id?.stringValue else {
                    showError("获取设备失败", superView: self.view)
                    return
                }
                self.loadDeviceDetails(deviceId)
            }
            
        default:
            ZZPrint("123")
        }

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dataSourceArr[section].count == 0 ? 0 : 32
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.createTableViewSectionHeader(tableView, section)
    }
    
    fileprivate func createTableViewSectionHeader(_ tableView: UITableView, _ section: Int) -> UIView {
        let bgView = UIView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: BOUNDS_WIDTH,
                                          height: self.tableView(tableView, heightForHeaderInSection: section)))
        bgView.backgroundColor = UIColor(rgb: 0xfafafa)
        let label = UILabel()
        label.text = tableHeaderTitleArr[section]
        bgView.addSubview(label)
        label.font = font_PingFangSC_Medium(14)
        label.textColor = UIColor(rgb: 0x333333)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(24)
            make.centerY.equalToSuperview()
        }
        return bgView
    }
}

//MARK: --------------- 网络请求 ------------------
extension HomeDeviceViewController {
    
    fileprivate func updateDataSourceAndRefresh(_ index: Int, models: [WashingModel]) {
        
        switch index {
        case 0:
            self.noPayDeviceArr = models
        case 1:
            self.noStartDevicenArr = models
        case 2:
            self.usingDeviceArr = models
        case 3:
            self.commonDeviceArr = models
        default:
            ZZPrint("")
        }
        
        emtpyDataView.isHidden = !dataSourceIsEmpty
        self.tableView.reloadData()
        
    }
    
    /// 获取推荐的设备
    fileprivate func loadCommonDeviceList() {
        DeviceViewModel.loadRecomendDevice_V2(1, 3, getUserId()) { (result) in
            
            self.endRefreshOrLoadMore()
            let result = result
            self.updateDataSourceAndRefresh(3, models: result.recommends)
        }
    }
    
    /// 获取下单后没有支付的设备
    fileprivate func loadNoPayDeviceList() {
        DeviceViewModel.loadNoPayDevices_V2(1, 20, getUserId()) { (devices, messages) in
            
            self.endRefreshOrLoadMore()
            
            guard let models = devices else { return }
            
            self.updateDataSourceAndRefresh(0, models: models)
        }
    }
    
    /// 获取需要开启的设备
    fileprivate func loadNoStartDeviceList() {
        DeviceViewModel.loadNoStartDevices_V2(1, 20, getUserId()) { (devices, messages) in
            
            self.endRefreshOrLoadMore()
            
            guard let models = devices else { return }
            
            self.updateDataSourceAndRefresh(1, models: models)
        }
    }
    
    /// 获取正在使用的设备
    fileprivate func loadUsingDeviceList() {
        
        DeviceViewModel.loadUsingDevices_V2(1, 20, getUserId()) { (devices, messages) in
            
            self.endRefreshOrLoadMore()
            
            guard let models = devices else { return }
            
            self.countDownTimer.fireDate = Date.distantFuture
            
            var dict = [String : Int]()
            
            for device in models {
                guard let deviceId = device.id?.stringValue else { continue }
                
                guard device.washStatus != 1 else { continue }
                
                dict[deviceId] = self.usingCountDownDict[deviceId] ?? 10
            }
            
            self.usingCountDownDict = dict
            
            var failStartArr = [String]()
            for deviceId in self.usingCountDownDict.keys {
                if self.startFailArr.contains(deviceId) {
                    failStartArr.append(deviceId)
                }
            }
            
            self.startFailArr = failStartArr
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                self.countDownTimer.fireDate = dict.isEmpty ? Date.distantFuture : Date.distantPast
            })
            
            self.updateDataSourceAndRefresh(2, models: models)
        }
    }
    
    /// 查询用户在该设备上的订单
    fileprivate func queryOrder(productId: String) {
        self.showWaitingView(keyWindow)
        OrderViewModel.inquiryOrder(productId, getUserId()) { (orderModel, message) in
            self.hiddenWaitingView()
            guard let model = orderModel else {
                self.refresh()
                showError(message, superView: self.view)
                return
            }
            if model.processPattern == .equipmentCoemmunication {
                OrderViewModel.pushOrderDetailsVC(model.id, self)
            } else {
                OrderViewModel.pushBlowerOrderVC(orderId: model.id?.stringValue ?? "", superController: self)
            }
        }
    }
    
    /// 获取设备详情
    fileprivate func loadDeviceDetails(_ deviceId: String) {
        
        self.showWaitingView(self.view)
        DeviceViewModel.loadWasherDetails(deviceId, NCLocation.message.coordinate2D, getUserId()) { (deviceModel, message) in
            self.hiddenWaitingView()
            if let model = deviceModel {
                if model.isEmpty {
                    DeviceViewModel.pushWashingPayVC(model, self)
                } else {
                    let alert = "洗衣机当前" + model.washStatusStr + "，请选择其他空闲设备"
                    self.alertSurePrompt(message: alert)
                }
            } else {
                showError(message, superView: self.view)
            }
        }

    }
}

extension HomeDeviceViewController {
    /// 加载并展示首页横幅广告
    func loadAndShowCurrentPageADS() {
        
        ADSManager.getADSList(ADSID: ADSManager.homeID, pageKeywords: "社区", adsSize: CGSize(width: 640, height: 100)) { (adses) in
            guard let adsModel = adses.first else {return}
            
            self.bannerADSView.set(adsModel.image, adsModel.title, adsModel.desc)
            
            if self.bannerADSView.superview == nil {
                self.view.addSubview(self.bannerADSView)
                self.bannerADSView.snp.makeConstraints { (make) in
                    make.bottom.equalTo(is_iPhoneX ? -(TABBAR_HEIGHT+5) : -5)
                    make.centerX.equalToSuperview()
                    make.width.equalTo(320)
                    make.height.equalTo(50)
                }
            }
            
            self.bannerADSView.touchSelfClosure = { [weak self] point in
                ADSManager.onClick(adsModel: adsModel, vc: self!, tapPoint: point, adsSize: CGSize(width: 640, height: 100))
            }
            self.bannerADSView.clickCloseClosure = { [weak self] in
                self?.bannerADSView.removeFromSuperview()
            }
            
            ADSManager.reportAfterShowed(adsModel: adsModel)
        }
    }

}






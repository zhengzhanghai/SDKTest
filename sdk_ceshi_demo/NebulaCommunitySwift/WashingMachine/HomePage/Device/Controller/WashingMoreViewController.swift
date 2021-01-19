//
//  WashingMoreViewController.swift
//  WashingMachine
//
//  Created by zzh on 17/3/9.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit
import MJRefresh

class WashingMoreViewController: BaseViewController {

    var schoolPlace: School?
    
    fileprivate var titleLabel:UILabel!
    fileprivate var allCountLabel:UILabel!
    
    fileprivate var tableView: UITableView!
    fileprivate var washingListData: [WashingModel] = [WashingModel]()
    
    fileprivate var loadPage: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = BACKGROUNDCOLOR
        self.addTopBlueView()
        self.updateTopBaseInfo()
        self.makeTableView()
        self.loadWashingMachineList(loadWay: 1)
    }
    
    fileprivate func updateTopBaseInfo() {
        guard let school = schoolPlace else {
            return
        }
        self.titleLabel.text = school.showName ?? ""
        
        var text = ""
        for deviceType in school.deviceTypeList {
            let type = Device.type(deviceType.deviceType)
            switch type {
            case .pulsatorWasher:
                text += "\(text.isEmpty ? "" : "  ")洗衣机:\(deviceType.sum ?? 0)台"
            case .blower:
                text += "\(text.isEmpty ? "" : "  ")吹风机:\(deviceType.sum ?? 0)台"
            case .dryer:
                text += "\(text.isEmpty ? "" : "  ")干衣机:\(deviceType.sum ?? 0)台"
            case .XXJ:
                text += "\(text.isEmpty ? "" : "  ")洗鞋机:\(deviceType.sum ?? 0)台"
            case .condensateBeads:
                text += "\(text.isEmpty ? "" : "  ")洗衣凝珠:\(deviceType.sum ?? 0)台"
            case .rollerWasher:
                text += "\(text.isEmpty ? "" : "  ")滚筒洗衣机:\(deviceType.sum ?? 0)台"
            default: break
            }
        }
        self.allCountLabel.text = text
    }
    
    fileprivate func makeTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 65, width: BOUNDS_WIDTH, height: BOUNDS_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-65), style: UITableView.Style.plain)
        self.view.addSubview(tableView)
        tableView.backgroundColor = BACKGROUNDCOLOR
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: 10))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: 10))
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        // 下拉刷新
        tableView.nc_addRefreshHeader { [weak self] in
            self?.loadPage = 1
            self?.loadWashingMachineList()
        }
        
        //上拉加载
        tableView.nc_addLoadMoreFooter { [weak self] in
            if self?.washingListData == nil || self?.washingListData.count == 0 {
                self?.loadPage = 1
            } else {
                self?.loadPage = (self?.loadPage ?? 1) + 1
            }
            self?.loadWashingMachineList()
        }
        
        CommonEquipmentEmptyCell.register(toTabeView: tableView)
        CommonEquipmentDisabledCell.register(toTabeView: tableView)
    }

    
    fileprivate func addTopBlueView() {
        let blueView = UIView(frame: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: 65))
        blueView.backgroundColor = THEMECOLOR
        self.view.addSubview(blueView)
        
        titleLabel = UILabel()
        blueView.addSubview(titleLabel)
        titleLabel.frame = CGRect(x: 16, y: 0, width: BOUNDS_WIDTH-32, height: 40)
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 0
        
        allCountLabel = UILabel()
        blueView.addSubview(allCountLabel)
        allCountLabel.numberOfLines = 0
        allCountLabel.textColor = UIColor(rgb: 0xbdd6ff)
        allCountLabel.font = UIFont.systemFont(ofSize: floatFromScreen(10))
        allCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom)
            make.left.equalTo(self.titleLabel)
            make.height.equalTo(22)
            make.right.equalTo(-16)
        }
    }
    
    func gotoLogin() {
        let loginVC = LoginViewController()
        loginVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(loginVC, animated: true)
    }

    // 判断设备是否空闲
    fileprivate func isEmpty(washModel: WashingModel) -> Bool {
        if washModel.onOffStatus != 0 {
            if washModel.washStatus == 2 {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    fileprivate func washingModelStatus(washModel: WashingModel) -> String {
        if self.isEmpty(washModel: washModel) {
            return "空闲"
        } else {
            if washModel.onOffStatus == 0 {
                return "离线"
            } else {
                if washModel.washStatus == 3 {
                    return "已预约"
                } else {
                    return "使用中"
                }
            }
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK:  _____________________________Network
extension WashingMoreViewController {
    // 获取洗衣机列表
    fileprivate func loadWashingMachineList(loadWay: Int = 0) {
        let url = String(format: "%@%@?longitude=%lf&latitude=%lf&userId=%@&parentId=%@&page=%d&size=%@",
                         SERVICE_BASE_ADDRESS,
                         API_GET_FLOOR_WASHINGMACHINE,
                         NCLocation.message.coordinate2D.longitude,
                         NCLocation.message.coordinate2D.latitude,
                         getUserId(),
                         self.schoolPlace?.id?.stringValue ?? "",
                         self.loadPage,
                         "20")
        if loadWay != 0 {
            self.showWaitingView(self.view)
        }
        NetworkEngine.get(url, parameters: nil) { (result) in
            self.tableView.nc_endRefresh()
            if loadWay != 0 {
                self.hiddenWaitingView()
            }
            guard (result.code == 204 || result.isSuccess) else {
                self.loadPage = 1
                self.washingListData.removeAll()
                self.tableView.reloadData()
                showError(result.message, superView: self.view)
                return
            }
            
            var washingList = [WashingModel]()
            if let items = result.dataObj["data"] as? [[String: Any]] {
                for i in 0 ..< items.count {
                    washingList.append(WashingModel.createDevice(items[i]))
                }
            }
            if self.loadPage == 1 {
                self.washingListData = washingList
            } else {
                for model in washingList {
                    self.washingListData.append(model)
                }
            }
            
            if washingList.count < 20 {
                self.tableView.nc_endRefreshingWithNoMoreData()
            } else {
                self.tableView.nc_resetNotMoreData()
            }
            
            self.tableView.reloadData()
        }
    }
    
    // 洗衣机详情
    fileprivate func washingMachineDetails(_ washModel: WashingModel) {
        self.showWaitingView(self.view)
        DeviceViewModel.loadWasherDetails(washModel.id?.stringValue ?? "", NCLocation.message.coordinate2D, getUserId()) { (washerModel, message) in
            self.hiddenWaitingView()
            if let model = washerModel {
                if model.isEmpty {
                    DeviceViewModel.pushWashingPayVC(model, self)
                } else {
                    let alert = "洗衣机当前" + washModel.washStatusStr + "，请选择其他空闲设备"
                    self.alertSurePrompt(message: alert)
                }
            } else {
                showError(message, superView: self.view)
            }
        }
    }

}

//MARK:  _____________________________UITableViewDelegate
extension WashingMoreViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return washingListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return DeviceListCellFactory.create(tableView,
                                            indexPath,
                                            washingListData[indexPath.row],
                                            { [unowned self] (action) in
            
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // 如果没有登录，去登录
        if !isLogin() {
            self.gotoLogin()
            return
        }
        
        let model = washingListData[indexPath.row]
        if model.processPattern == .onewayCommunication {
            // 如果是吹风机，直接进入使用吹风机页面
            let vc = UseBlowerViewController(model)
            self.pushViewController(vc)
        } else if model.processPattern == .equipmentCoemmunication {
            //  如果是洗衣机，先去刷新洗衣机信息，如果可用，进入使用洗衣机页面
            self.washingMachineDetails(model)
        }
    }
    
}


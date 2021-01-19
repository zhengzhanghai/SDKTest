//
//  WashingFloorViewController.swift
//  WashingMachine
//
//  Created by zzh on 2017/7/12.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class WashingFloorViewController: BaseTableViewController {
    
    var schoolId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "附近设备"
        self.tableView.hz_height = BOUNDS_HEIGHT-TABBAR_HEIGHT
        self.configPullUpLoadMoreFooter()
        self.configPullDownRefreshHeader()
        self.cancelTableViewSeparatorLine()
        NebryDeviceFloorCell.register(toTabeView: self.tableView)
        self.loadNearbyFloor(.normal)
    
    }
    
    override func pullDownRefresh() {
        super.pullDownRefresh()
        self.loadNearbyFloor(.refresh)
    }
    
    override func pullUpLoadMore() {
        super.pullUpLoadMore()
        self.loadNearbyFloor(.more)
    }
    
    fileprivate func loadNearbyFloor(_ loadWay: NCNetworkLoadWay) {
        self.tableShowLoadingView(loadWay, self.view)
        DeviceViewModel.loadNebyFloor(NCLocation.message.coordinate2D, schoolId, "\(loadPage)", "\(pageSize)") { (models, message) in
            self.tableHiddenLoadingView(loadWay)
            self.endRefreshOrLoadMore()
            guard let floors = models else {
                self.clearAllDataAndRefreshTableView()
                showError(message, superView: self.view)
                return
            }
            self.dealWithListDataAndRefresh(loadWay, floors)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


//MARK:  ********  tableViewDalegate，tableViewDatasource  ********
extension WashingFloorViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = NebryDeviceFloorCell.create(tableView, indexPath)
        let model = (dataSource[indexPath.row] as? School) ?? School()
        (cell as? NebryDeviceFloorCell)?.configData(model)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        DeviceViewModel.pushMoreWashingListVC(dataSource[indexPath.row] as? School, self)
    }
}




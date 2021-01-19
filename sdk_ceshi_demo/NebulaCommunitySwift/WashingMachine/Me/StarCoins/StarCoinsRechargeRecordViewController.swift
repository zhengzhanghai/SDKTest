//
//  StarCoinsRechargeRecordViewController.swift
//  WashingMachine
//
//  Created by Harious on 2018/3/30.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

class StarCoinsRechargeRecordViewController: NCTableListViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 设置导航栏背景色
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        // 设置导航栏上一些非自定义按钮颜色
        self.navigationController?.navigationBar.tintColor = UIColor.black
        // 设置导航栏标题文字颜色及字体
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                        NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18)]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 设置导航栏背景色
        self.navigationController?.navigationBar.barTintColor = THEMECOLOR
        // 设置导航栏上一些非自定义按钮颜色
        self.navigationController?.navigationBar.tintColor = UIColor.white
        // 设置导航栏标题文字颜色及字体
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                        NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18)]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = BACKGROUNDCOLOR
        TableCell.register(toTabeView: tableView)
        
        loadRechargeList()
    }
    
    override func pullDownRefresh() {
        super.pullDownRefresh()
        
        self.loadRechargeList(loadway: .refresh, page: loadPage, size: loadSize)
    }
    
    override func pullUpMore() {
        super.pullUpMore()
        
        self.loadRechargeList(loadway: .more, page: loadPage, size: loadSize)
    }

}

extension StarCoinsRechargeRecordViewController {
    
    fileprivate func loadRechargeList(loadway: NCNetworkLoadWay = .normal, page: Int = 1, size: Int = 20) {
        
        let parameters = ["userId": getUserId(), "page": page, "size": size] as [String: Any]
        
        NetworkEngine.get(api_get_star_coins_recharge_record(userId: getUserId()),
                          parameters: parameters)
        { (result) in
            
            self.tableView.nc_endRefresh()
            
            guard result.error == nil && result.isSuccessOr204 else {
                self.loadPageReduce()
                showError(result.message, superView: self.view)
                return
            }
            
            var models = [StarCoinsRechargeRecord]()
            if let dataArr = (result.dataObj as? [String: Any])?["data"] as? [[String: Any]] {
                for dict in dataArr {
                    models.append(StarCoinsRechargeRecord.create(dict))
                }
            }
            
            self.dealWithDataAndRefreshTable(loadway, models)
        }
    }
}

extension StarCoinsRechargeRecordViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return (TableCell.create(tableView, indexPath) as! TableCell)
            .config(rechargeRecord: dataSource[indexPath.row] as! StarCoinsRechargeRecord)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 11
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension StarCoinsRechargeRecordViewController {
    
    class TableCell: BaseTableViewCell {
        
        lazy var rechargeLabel: UILabel = {
            return createLabel("",
                               textColor: UIColor_0x(0x333333),
                               font: font_PingFangSC_Regular(14),
                               superView: contentView)
        }()
        lazy var costRMBLabel: UILabel = {
            return createLabel("",
                               textColor: THEMECOLOR,
                               font: font_PingFangSC_Regular(14),
                               superView: contentView)
        }()
        lazy var payWayLabel: UILabel = {
            return createLabel("",
                               textColor: UIColor_0x(0x9b9b9b),
                               font: font_PingFangSC_Regular(12),
                               superView: contentView)
        }()
        lazy var rechargeTimeLabel: UILabel = {
            let label = createLabel("",
                                    textColor: UIColor_0x(0x9b9b9b),
                                    font: font_PingFangSC_Regular(12),
                                    superView: contentView)
            label.textAlignment = .right
            return label
        }()
        lazy var orderNoLabel: UILabel = {
            return createLabel("",
                               textColor: UIColor_0x(0x9b9b9b),
                               font: font_PingFangSC_Regular(12),
                               superView: contentView)
        }()
        
        @discardableResult
        func config(rechargeRecord: StarCoinsRechargeRecord) -> Self {
            rechargeLabel.text = "充值\(rechargeRecord.nebulaCoinStr)元"
            if let status = rechargeRecord.status?.intValue {
                costRMBLabel.text = (status == 1) ? "¥\(rechargeRecord.priceStr)" : ((status == 0) ? "取消充值" : "充值失败")
                costRMBLabel.textColor = (status == 1) ? THEMECOLOR : UIColor_0x(0xbb8170)
            } else {
                costRMBLabel.text = ""
            }
            payWayLabel.text = "支付方式：\(rechargeRecord.payTypeStr)"
            rechargeTimeLabel.text = (rechargeRecord.createTime != nil) ? rechargeRecord.createTime!.timeStr(dateFormat: "yyyy-MM-dd HH:mm") : " "
            orderNoLabel.text = "订单号：\(rechargeRecord.rechargeNo ?? " ")"
            
            return self
        }
        
        override func createUI() {
            super.createUI()
            
            rechargeLabel.snp.makeConstraints { (make) in
                make.top.equalTo(16)
                make.left.equalTo(18)
                make.width.lessThanOrEqualTo(BOUNDS_WIDTH-130)
            }
            costRMBLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(self.rechargeLabel)
                make.right.equalTo(-18)
                make.width.lessThanOrEqualTo(80)
            }
            payWayLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.rechargeLabel.snp.bottom).offset(5)
                make.left.equalTo(18)
                make.width.lessThanOrEqualTo(BOUNDS_WIDTH/2)
            }
            rechargeTimeLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(self.payWayLabel)
                make.right.equalTo(-18)
                make.width.lessThanOrEqualTo(BOUNDS_WIDTH/2-45)
            }
            orderNoLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.payWayLabel.snp.bottom).offset(5)
                make.left.equalTo(18)
                make.right.equalTo(-18)
                make.bottom.equalTo(-16)
            }
        }
    }
}

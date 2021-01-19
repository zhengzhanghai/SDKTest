//
//  StarCoinsConsumptionRecordViewController.swift
//  WashingMachine
//
//  Created by Harious on 2018/3/30.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

class StarCoinsConsumptionRecordViewController: NCTableListViewController {
    
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
        
        self.loadConsumptionList()
    }
    
    override func pullDownRefresh() {
        super.pullDownRefresh()
        
        self.loadConsumptionList(loadway: .refresh, page: loadPage, size: loadSize)
    }
    
    override func pullUpMore() {
        super.pullUpMore()
        
        self.loadConsumptionList(loadway: .more, page: loadPage, size: loadSize)
    }
    
}

extension StarCoinsConsumptionRecordViewController {
    
    fileprivate func loadConsumptionList(loadway: NCNetworkLoadWay = .normal, page: Int = 1, size: Int = 20) {
        
        let parameters = ["userId": getUserId(), "page": page, "size": size] as [String: Any]
        
        NetworkEngine.get(api_get_star_coins_consumption_record(userId: getUserId()),
                          parameters: parameters)
        { (result) in
            
            self.tableView.nc_endRefresh()
            
            guard result.error == nil && result.isSuccessOr204 else {
                self.loadPageReduce()
                showError(result.message, superView: self.view)
                return
            }
            
            var models = [StarCoinsConsumptionRecord]()
            if let dataArr = (result.dataObj as? [String: Any])?["data"] as? [[String: Any]] {
                for dict in dataArr {
                    models.append(StarCoinsConsumptionRecord.create(dict))
                }
            }
            
            self.dealWithDataAndRefreshTable(loadway, models)
        }
    }
}

extension StarCoinsConsumptionRecordViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return (TableCell.create(tableView, indexPath) as! TableCell)
            .config(consumptionRecord: dataSource[indexPath.row] as! StarCoinsConsumptionRecord)
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

extension StarCoinsConsumptionRecordViewController {
    
    class TableCell: BaseTableViewCell {
        
        lazy var titleLabel: UILabel = {
            let label = createLabel("",
                                    textColor: UIColor_0x(0x333333),
                                    font: font_PingFangSC_Regular(14),
                                    superView: contentView)
            label.numberOfLines = 0
            return label
        }()
        lazy var costStarCoinsLabel: UILabel = {
            return createLabel("",
                               textColor: THEMECOLOR,
                               font: font_PingFangSC_Regular(14),
                               superView: contentView)
        }()
        lazy var orderNoLabel: UILabel = {
            return createLabel("",
                               textColor: UIColor_0x(0x9b9b9b),
                               font: font_PingFangSC_Regular(12),
                               superView: contentView)
        }()
        lazy var consumptionTimeLabel: UILabel = {
            let label = createLabel("",
                                    textColor: UIColor_0x(0x9b9b9b),
                                    font: font_PingFangSC_Regular(12),
                                    superView: contentView)
            label.textAlignment = .right
            return label
        }()
        
        @discardableResult
        func config(consumptionRecord record: StarCoinsConsumptionRecord) -> Self {
            titleLabel.text = (record.type == 1) ?  (record.showName ?? "") : "退款"
            costStarCoinsLabel.text = "\((record.type == 1) ?  "-" : "+")\(record.nebulaCoinStr)元"
            orderNoLabel.text = "订单号：\(record.orderSn ?? "")"
            consumptionTimeLabel.text = (record.createTime != nil) ? record.createTime!.timeStr(dateFormat: "yyyy-MM-dd HH:mm") : " "
            
            return self
        }
        
        override func createUI() {
            super.createUI()
            
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(16)
                make.left.equalTo(18)
                make.width.lessThanOrEqualTo(BOUNDS_WIDTH-110)
            }
            costStarCoinsLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(self.titleLabel)
                make.right.equalTo(-18)
                make.width.lessThanOrEqualTo(60)
            }
            orderNoLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.titleLabel.snp.bottom).offset(5)
                make.left.equalTo(18)
                make.width.lessThanOrEqualTo(BOUNDS_WIDTH/2)
            }
            consumptionTimeLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(self.orderNoLabel)
                make.right.equalTo(-18)
                make.width.lessThanOrEqualTo(BOUNDS_WIDTH/2-45)
                make.bottom.equalTo(-16)
            }
        }
    }
}

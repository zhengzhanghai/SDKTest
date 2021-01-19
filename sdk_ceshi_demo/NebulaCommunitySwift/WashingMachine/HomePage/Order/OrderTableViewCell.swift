//
//  OrderTableViewCell.swift
//  WashingMachine
//
//  Created by zzh on 17/3/10.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func create(tableView: UITableView) -> OrderTableViewCell {
        let reString = NSStringFromClass(self.classForCoder())
        let reuserString = reString.components(separatedBy: ".").last ?? ""
        tableView.register(OrderTableViewCell.classForCoder(), forCellReuseIdentifier: reuserString)
        return tableView.dequeueReusableCell(withIdentifier: reuserString) as! OrderTableViewCell
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = BACKGROUNDCOLOR
        self.initUI()
    }
    
    func refreshUI(model: OrderDetailsModel) {
//        self.statusLabel.text = model.washStatusString ?? ""
        self.titleLabel.text = model.baseName ?? ""
        self.timeLabel.text = timeStringFromTimeStamp(timeStamp: (model.createTime?.doubleValue)!)
        self.ordereNoLabel.text = "订单号:" + (model.orderNo ?? "")!
        
        switch model.status ?? -1 {
        case 0:
            self.statusLabel.text = "无效订单"
            self.statusLabel.textColor = UIColor(rgb: 0x999999)
        case 1:
            self.statusLabel.text = "待支付"
            self.statusLabel.textColor = UIColor(rgb: 0xF12626)
        case 2:
            self.statusLabel.text = "支付失败"
            self.statusLabel.textColor = UIColor(rgb: 0x999999)
        case 3:
            self.statusLabel.textColor = UIColor(rgb: 0x08c847)
            if model.orderFrom == 2 {//预约
                self.statusLabel.text = "已预约"
                //详情页应该有个启动按钮
            }else if model.orderFrom == 1{//一键下单
                self.statusLabel.text = model.washStatusString
                //详情页有个退款按钮
            }
        case 4:
            self.statusLabel.textColor = UIColor(rgb: 0x08c847)
            self.statusLabel.text = model.washStatusString
        case 5:
            self.statusLabel.text = "已完成"
            self.statusLabel.textColor = UIColor(rgb: 0x999999)
        case 6:
            self.statusLabel.text = "退款申请中"
            self.statusLabel.textColor = UIColor(rgb: 0x6684EA)
        case 7:
            self.statusLabel.text = "退款申请中"
            self.statusLabel.textColor = UIColor(rgb: 0x6684EA)
        case 8:
            self.statusLabel.text = "退款失败"
            self.statusLabel.textColor = UIColor(rgb: 0x6684EA)
        case 9:
            self.statusLabel.text = "已退款"
            self.statusLabel.textColor = UIColor(rgb: 0x999999)
        case 10:
            self.statusLabel.text = "订单超时"
            self.statusLabel.textColor = UIColor(rgb: 0x999999)
        case 11:
            self.statusLabel.text = "支付超时"
            self.statusLabel.textColor = UIColor(rgb: 0x999999)
        case 12:
            self.statusLabel.text = "订单已取消"
            self.statusLabel.textColor = UIColor(rgb: 0x999999)
        case 13:
            self.statusLabel.text = "拒绝退款"
            self.statusLabel.textColor = UIColor(rgb: 0x6684EA)
        default:
            print("")
        }
        self.statusLabel.text = model.statusStr
    }
    
    fileprivate func initUI() {
        self.contentView.addSubview(self.bgView)
        self.bgView.addSubview(self.statusLabel)
        self.bgView.addSubview(self.titleLabel)
        self.bgView.addSubview(self.timeLabel)
        self.bgView.addSubview(self.ordereNoLabel)
        
        self.bgView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.width.equalTo(BOUNDS_WIDTH)
            make.bottom.equalTo(-10)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(10)
            make.width.equalTo(BOUNDS_WIDTH-32)
        }
        self.ordereNoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            make.width.lessThanOrEqualTo(BOUNDS_WIDTH-32)
        }
        self.timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(self.ordereNoLabel.snp.bottom).offset(10)
            make.bottom.equalTo(-10)
        }
        self.statusLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-16)
            make.centerY.equalTo(self.timeLabel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate lazy var bgView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = DEEPCOLOR
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 2
        return label
    }()
    
    fileprivate lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    fileprivate lazy var ordereNoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UNDERTINTCOLOR
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    fileprivate lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UNDERTINTCOLOR
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
}

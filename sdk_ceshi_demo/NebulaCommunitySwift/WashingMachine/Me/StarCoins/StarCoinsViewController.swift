//
//  StarCoinsViewController.swift
//  WashingMachine
//
//  Created by Harious on 2018/3/29.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON

class StarCoinsViewController: BaseViewController {
    
    let cellTitles = ["充值记录", "消费记录"]
    
    var vm: ViewModel!
    
    lazy var tableView: UITableView = { [unowned self] in
        let table = UITableView(frame: self.view.bounds, style: .plain)
        table.backgroundColor = BACKGROUNDCOLOR
        table.delegate = self
        table.dataSource = self
        table.tableHeaderView = self.tableHeader
        table.tableFooterView = UIView()
        table.separatorInset = UIEdgeInsets.zero
        TableCell.register(toTabeView: table)
        return table
    }()
    lazy var tableHeader: TableHeader = {
        let header = TableHeader(frame: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: 200))
        return header
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableHeader.setNebulaCoinsText(coins: UserBalanceManager.share.balance ?? 0)
        vm.loadStarCoinsBalance()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "我的余额"
        
        vm = ViewModel(vc: self)
        
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

    }

}

extension StarCoinsViewController {
    
    class ViewModel {
        
        weak var vc: StarCoinsViewController?
        
        lazy var disposeBag: DisposeBag = {
            return DisposeBag()
        }()
        
        init(vc: StarCoinsViewController) {
            self.vc = vc
            self.rxBinding()
        }
        
        fileprivate func rxBinding() {
            
            vc?.tableHeader.rechargeBtn.rx.tap.subscribe(onNext: { [unowned self] in
                self.vc?.pushViewController(StarCoinsRechargeViewController())
            }).disposed(by: disposeBag)
        }
        
        /// 获取星币余额
        func loadStarCoinsBalance() {
            
            UserBalanceManager.share.asynRefreshBalance { (isSuccess, amount) in
                if isSuccess {
                    self.vc?.tableHeader.setNebulaCoinsText(coins: amount)
                } else {
                    
                }
            }
        
        }
    }
}

//MARK: --------------- UITableViewDelegate, UITableViewDataSource ------------------
extension StarCoinsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableCell.create(tableView, indexPath) as! TableCell
        cell.titleLabel.text = cellTitles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = StarCoinsRecordViewController()
        vc.type = indexPath.row == 0 ? .recharge : .consumption
        self.pushViewController(vc)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 7
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}

//MARK: --------------- tableview 头视图 ------------------
extension StarCoinsViewController {
    
    class TableHeader: UIView {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.backgroundColor = UIColor.white
            
            self.addSubview(self.balanceLabel)
            self.addSubview(self.starCoinsLabel)
            self.addSubview(self.rechargeBtn)
            self.addSubview(self.sepline)
            
            self.setNebulaCoinsText(coins: 0)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        lazy var balanceLabel: UILabel = { 
            return createLabel("余额",
                               textColor: UIColor_0x(0x4a4a4a),
                               font: font_PingFangSC_Regular(14),
                               superView: self)
        }()
        lazy var starCoinsLabel: UILabel = {
            let label = createLabel("",
                                    textColor: THEMECOLOR,
                                    font: font_709_CAI978(32),
                                    superView: self)
            return label
        }()
        lazy var rechargeBtn: UIButton = {
            let btn = UIButton(type: .custom)
            btn.backgroundColor = THEMECOLOR
            btn.setTitle("充值", for: .normal)
            btn.titleLabel?.font = font_PingFangSC_Regular(15)
            btn.setRoundCornerRadius()
            return btn
        }()
        lazy var sepline: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor_0x(0xe4e4e4)
            return view
        }()
        
        /// 设置余额金额
        func setNebulaCoinsText(coins: Float) {
            let amountStr = coins.string(decimalPlaces: 2)
            let unitStr = "元"
            let attMuStr = NSMutableAttributedString(string: amountStr + unitStr)
            attMuStr.addAttributes([NSAttributedString.Key.font: font_PingFangSC_Semibold(24)],
                                   range: NSMakeRange(amountStr.count-3, 3))
            attMuStr.addAttributes([NSAttributedString.Key.font: font_PingFangSC_Regular(10),
                                    NSAttributedString.Key.foregroundColor: UIColor_0x(0x9b9b9b)],
                                   range: NSMakeRange(amountStr.count, unitStr.count))
            starCoinsLabel.attributedText = attMuStr
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            balanceLabel.snp.makeConstraints { (make) in
                make.top.equalTo(24)
                make.centerX.equalToSuperview()
            }
            starCoinsLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.balanceLabel.snp.bottom).offset(1)
                make.centerX.equalToSuperview()
            }
            rechargeBtn.snp.makeConstraints { (make) in
                make.top.equalTo(self.starCoinsLabel.snp.bottom).offset(24)
                make.centerX.equalToSuperview()
                make.width.height.equalTo(60)
            }
            sepline.snp.makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(0.5)
            }
        }
    }
}

//MARK: --------------- cell ------------------
extension StarCoinsViewController {
    class TableCell: BaseTableViewCell {
        
        lazy var titleLabel: UILabel = {
            return createLabel("",
                               textColor: UIColor_0x(0x4a4a4a),
                               font: font_PingFangSC_Regular(12),
                               superView: self.contentView)
        }()
        lazy var enterIconImageView: UIImageView = {
            return UIImageView(image: #imageLiteral(resourceName: "enter"))
        }()
        
        override func createUI() {
            super.createUI()
            
            self.contentView.addSubview(titleLabel)
            self.contentView.addSubview(enterIconImageView)
            
            titleLabel.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.left.equalTo(20)
            }
            enterIconImageView.snp.makeConstraints { (make) in
                make.right.equalTo(-15)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(20)
            }
        }
        
        
    }
}

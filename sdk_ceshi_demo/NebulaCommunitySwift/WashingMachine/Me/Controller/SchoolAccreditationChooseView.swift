//
//  SchoolAccreditationChooseView.swift
//  WashingMachine
//
//  Created by 郑章海 on 2020/12/29.
//  Copyright © 2020 Eteclabeteclab. All rights reserved.
//

import UIKit

protocol SchoolAccreditationModelProtocol {
    var name: String? { get }
}

class SchoolAccreditationChooseView: UIView {
    
    var didSelectedItem: ((Int, SchoolAccreditationModelProtocol) -> ())?
    var closeClosure: (() -> ())?
    
    fileprivate var datasources: [SchoolAccreditationModelProtocol] = []
    
    fileprivate lazy var contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        return view
    }()
    fileprivate lazy var titleLbael: UILabel = {
        let label = UILabel()
        label.font = font_PingFangSC_Regular(14)
        label.textColor = UIColor(rgb: 0x333333)
        return label
    }()
    fileprivate lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .red
        btn.setImage(UIImage(named: ""), for: .normal)
        return btn
    }()
    fileprivate lazy var tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero,style: .plain)
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.estimatedRowHeight = 80
        table.rowHeight = UITableView.automaticDimension
        Cell.registerTo(table)
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: public method
extension SchoolAccreditationChooseView {
    func show(title: String, datas: [SchoolAccreditationModelProtocol]) {
        titleLbael.text = title
        datasources = datas
        tableView.reloadData()
        
        showContentByAnimation()
    }
}

// MARK: UI布局及界面动画相关
fileprivate extension SchoolAccreditationChooseView {

    func showContentByAnimation(_ finish: (() -> ())? = nil) {
        UIView.animate(withDuration: 0.5) {
            self.backgroundColor = UIColor(rgb: 0x000000).withAlphaComponent(0.8)
            self.contentView.snp.updateConstraints { (make) in
                make.top.equalTo(BOUNDS_HEIGHT*0.25)
            }
            self.layoutIfNeeded()
        } completion: { (_) in
            finish?()
        }
    }
    
    func hiddenContentByAnimation(_ finish: (() -> ())? = nil) {
        UIView.animate(withDuration: 0.5) {
            self.backgroundColor = UIColor(rgb: 0x000000).withAlphaComponent(0)
            self.contentView.snp.updateConstraints { (make) in
                make.top.equalTo(BOUNDS_HEIGHT)
            }
            self.layoutIfNeeded()
        } completion: { (_) in
            finish?()
        }
    }
    
    func setupUI() {
        backgroundColor = UIColor(rgb: 0x000000).withAlphaComponent(0)
        addSubview(contentView)
        contentView.addSubview(titleLbael)
        contentView.addSubview(closeBtn)
        contentView.addSubview(tableView)
        
        contentView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(BOUNDS_HEIGHT)
            make.height.equalTo(BOUNDS_HEIGHT*0.75)
        }
        titleLbael.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        closeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-16)
            make.centerY.equalTo(titleLbael)
            make.width.height.equalTo(25)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: 事件响应相关
fileprivate extension SchoolAccreditationChooseView {
    @objc func onClickClose() {
        hiddenContentByAnimation({
            self.closeClosure?()
        })
    }
}

// tableView代理相关
extension SchoolAccreditationChooseView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Cell.create(tableView: tableView)
        cell.set(title: datasources[indexPath.row].name ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectedItem?(indexPath.row, datasources[indexPath.row])
    }
}

// MARK: class cell
extension SchoolAccreditationChooseView {
    
    class Cell: UITableViewCell {
        
        func set(title: String) {
            self.titleLabel.text = title
        }
        
        class func registerTo(_ tableView: UITableView) {
            tableView.register(Cell.classForCoder(), forCellReuseIdentifier: getReuseIdentifier())
        }
        
        class func create(tableView: UITableView) -> Cell {
            let cell = tableView.dequeueReusableCell(withIdentifier: getReuseIdentifier()) as! Cell
            return cell
        }
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.makeUI()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        fileprivate class func getReuseIdentifier() -> String {
            let reString = NSStringFromClass(self.classForCoder())
            let reuserString = reString.components(separatedBy: ".").last ?? ""
            return reuserString
        }
        
        fileprivate func makeUI() {
            selectionStyle = .none
            self.contentView.addSubview(self.titleLabel)
            self.titleLabel.snp.makeConstraints { (make) in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.top.equalTo(15)
                make.bottom.equalTo(-15)
            }
        }
        
        fileprivate lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.textColor = UIColor(rgb: 0x333333)
            label.font = UIFont.systemFont(ofSize: 16)
            return label;
        }()
    }
}

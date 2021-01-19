//
//  ChooseRegionCell.swift
//  WashingMachine
//
//  Created by zzh on 2017/5/2.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class ChooseRegionCell: UITableViewCell {
    
    func config(title: String) {
        self.titleLabel.text = title
    }
    
    class func create(tableView: UITableView) -> ChooseRegionCell {
        let reString = NSStringFromClass(self.classForCoder())
        let reuserString = reString.components(separatedBy: ".").last ?? ""
        tableView.register(ChooseRegionCell.classForCoder(), forCellReuseIdentifier: reuserString)
        let cell = tableView.dequeueReusableCell(withIdentifier: reuserString) as! ChooseRegionCell
        cell.selectionStyle = .none
        return cell
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func makeUI() {
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

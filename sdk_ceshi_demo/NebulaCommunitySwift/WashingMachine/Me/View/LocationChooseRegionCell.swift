//
//  LocationChooseRegionCell.swift
//  WashingMachine
//
//  Created by zzh on 2017/5/2.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class LocationChooseRegionCell: UITableViewCell {

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
        self.contentView.addSubview(self.locationIcon)
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(36)
            make.top.equalTo(25)
            make.bottom.equalTo(-15)
        }
        self.locationIcon.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.centerY.equalTo(self.titleLabel)
            make.width.height.equalTo(20)
        }
    }
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x333333)
        label.font = UIFont.systemFont(ofSize: 16)
        return label;
    }()
    
    fileprivate lazy var locationIcon: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "location")
        return imageView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }


}

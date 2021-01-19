//
//  BaseTableViewXIBCell.swift
//  WashingMachine
//
//  Created by zzh on 2017/8/25.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class BaseTableViewXIBCell: UITableViewCell {

    var indexPath: IndexPath?
    
    class func create(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier())
        (cell as? BaseTableViewXIBCell)?.indexPath = indexPath
        return cell ?? UITableViewCell()
    }
    
    /// 向UITableView注册本 XIB cell
    ///
    /// - Parameter toTabeView: UITableView
    class func registerXib(_ toTabeView: UITableView) {
        let nib = UINib.init(nibName: self.identifier(), bundle: nil)
        toTabeView.register(nib, forCellReuseIdentifier: self.identifier())
    }
    
    class func identifier() -> String {
        return NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last ?? ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

//
//  BaseTableViewCell.swift
//  WashingMachine
//
//  Created by zzh on 2017/7/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    var indexPath: IndexPath?
    
    
    static var identifier: String {
        return NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last ?? "cell"
    }
    
    /// 复用cell， 不带注册
    class func create(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier)
        (cell as? BaseTableViewCell)?.indexPath = indexPath
        return cell ?? UITableViewCell()
    }
    
    /// 向UITableView注册本cell
    ///
    /// - Parameter toTabeView: UITableView
    class func register(toTabeView: UITableView) {
        toTabeView.register(self.classForCoder(), forCellReuseIdentifier: self.identifier)
    }
    
    /// 向UITableView注册本 XIB cell
    ///
    /// - Parameter toTabeView: UITableView
    class func registerXib(_ toTabeView: UITableView) {
        let nib = UINib.init(nibName: self.identifier, bundle: nil)
        toTabeView.register(nib, forCellReuseIdentifier: self.identifier)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createUI() {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}

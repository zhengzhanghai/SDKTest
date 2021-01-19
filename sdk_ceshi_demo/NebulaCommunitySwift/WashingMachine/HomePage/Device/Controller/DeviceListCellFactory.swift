//
//  DeviceCellFactory.swift
//  WashingMachine
//
//  Created by Harious on 2018/1/15.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

class DeviceListCellFactory: NSObject {
    
    class func create(_ tableView: UITableView,
                      _ indexPath: IndexPath,
                      _ deviceModel: WashingModel,
                      _ action: ((DeviceCellEventType)->())? = nil) -> BaseTableViewCell
    {
        
        func createEmptyCell() -> CommonEquipmentEmptyCell {
            let  emptyCell = CommonEquipmentEmptyCell.create(tableView, indexPath) as! CommonEquipmentEmptyCell
            emptyCell.deviceNameLabel.text = deviceModel.showName
            emptyCell.icon.image = UIImage(named: deviceModel.cellSmallIcon)
            emptyCell.useClource = {
                action?(.use)
            }
            return emptyCell
        }
        
        func createDisabledCell() -> CommonEquipmentDisabledCell {
            let  disabledCell = CommonEquipmentDisabledCell.create(tableView, indexPath) as! CommonEquipmentDisabledCell
            disabledCell.deviceNameLabel.text = deviceModel.showName
            disabledCell.icon.image = UIImage(named: deviceModel.cellSmallIcon)
            /// 当设备处于不可用状态和可用状态下的图标透明度不同
            disabledCell.icon.alpha = deviceModel.isEmpty ? 1 : 0.5
            disabledCell.statusLabel.text = deviceModel.isOffLine ? "离线" : "\(deviceModel.washStatus == 3 ? "已预约：" :"运行中：") 剩余\(deviceModel.residualTime ?? "_")分钟"
            
            return disabledCell
        }
        
        return deviceModel.isEmpty ? createEmptyCell() : createDisabledCell()
        

    }
}

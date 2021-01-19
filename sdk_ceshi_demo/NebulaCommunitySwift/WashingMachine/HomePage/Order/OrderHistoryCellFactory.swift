//
//  OrderHistoryCellFactory.swift
//  WashingMachine
//
//  Created by Harious on 2018/1/12.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

class OrderHistoryCellFactory: NSObject {
    
    static func create(_ tableView: UITableView, _ indexPath: IndexPath, _ order: OrderDetailsModel) -> BaseTableViewCell {
        
        if order.isExistPassword {
            return self.createCodeCell(tableView, indexPath, order)
        } else {
            return self.createStatusCell(tableView, indexPath, order)
        }
       
    }
    
    fileprivate static func createCodeCell(_ tableView: UITableView, _ indexPath: IndexPath, _ order: OrderDetailsModel) -> OrderHistoryCodeCell {
        let cell = OrderHistoryCodeCell.create(tableView, indexPath) as! OrderHistoryCodeCell
        
        cell.deviceTypeNameLabel.text = Device.name(order.deviceType)
        cell.deviceNameLabel.text = order.baseName
        cell.dateLabel.text = order.createTimeStr
        cell.statusLabel.text = order.statusStr
        
        let type = Device.type(order.deviceType)
        cell.titleBGView.addGradientLayer(colors: getGradientColors(type: type), direction: .horizontal)
        cell.deviceTypeNameLabel.textColor = getDeviceTypeColor(type: type)
        cell.codeLabel.text = order.drierPassword
        return cell
    }
    
    fileprivate static func createStatusCell(_ tableView: UITableView, _ indexPath: IndexPath, _ order: OrderDetailsModel) -> OrderHistoryStatusCell {
        let cell = OrderHistoryStatusCell.create(tableView, indexPath) as! OrderHistoryStatusCell
        cell.deviceTypeNameLabel.text = Device.name(order.deviceType)
        cell.deviceNameLabel.text = order.baseName
        cell.dateLabel.text = order.createTimeStr
        cell.statusLabel.text = order.statusStr
        
        let type = Device.type(order.deviceType)
        cell.titleBGView.addGradientLayer(colors: getGradientColors(type: type), direction: .horizontal)
        cell.deviceTypeNameLabel.textColor = getDeviceTypeColor(type: type)
        return cell
    }
    
    static func getGradientColors(type: DeviceType) -> [UIColor] {
        switch type {
        case .pulsatorWasher, .rollerWasher:
            return [UIColor(rgb: 0xF2F9FF), UIColor(rgb: 0xFFFFFF)]
        case .XXJ:
            return [UIColor(rgb: 0xF4F2FF), UIColor(rgb: 0xFFFFFF)]
        case .blower:
            return [UIColor(rgb: 0xF4FFF2), UIColor(rgb: 0xFFFFFF)]
        case .dryer:
            return [UIColor(rgb: 0xFFFBF2), UIColor(rgb: 0xFFFFFF)]
        default:
            return [UIColor(rgb: 0xF2F9FF), UIColor(rgb: 0xFFFFFF)]
        }
    }
    
    static func getDeviceTypeColor(type: DeviceType) -> UIColor {
        switch type {
        case .pulsatorWasher, .rollerWasher:
            return UIColor(rgb: 0x3399FF)
        case .XXJ:
            return UIColor(rgb: 0x7F66FF)
        case .blower:
            return UIColor(rgb: 0x3BB324)
        case .dryer:
            return UIColor(rgb: 0xFFAA00)
        default:
            return UIColor(rgb: 0x3399FF)
        }
    }
}

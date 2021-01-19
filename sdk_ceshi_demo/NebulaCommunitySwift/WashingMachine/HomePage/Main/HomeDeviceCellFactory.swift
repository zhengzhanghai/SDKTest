//
//  HomeDeviceCellFactory.swift
//  WashingMachine
//
//  Created by Harious on 2018/1/11.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

enum DeviceCellEventType {
    case use   // 立即使用
    case start // 开启洗衣机
    case pay   // 立即支付
    case contactTheMerchant // 联系商家
}

class HomeDeviceCellFactory: NSObject {

    class func create(_ tableView: UITableView,
                      _ indexPath: IndexPath,
                      _ device: WashingModel,
                      _ countDownDict: [String: Int],
                      _ action: ((DeviceCellEventType)->())? = nil) -> BaseTableViewCell
    {
        let cell : BaseTableViewCell!
        let section = indexPath.section
        
        switch section {
//        case 0:
//
//            /// 去扫码的cell
//            cell = DeviceEmptyScanCell.create(tableView, indexPath) as! DeviceEmptyScanCell
            
        case 0, 1, 2:
            
            /// 需要支付、启动设备、使用中设备的cell
            
            let usingCell = HomeDeviceUsingCell.create(tableView, indexPath) as! HomeDeviceUsingCell
            usingCell.deviceNameLabel.text = device.showName
            
            usingCell.icon.image = UIImage(named: device.cellIcon)
            /// 目前正常来说，section==2，只有双向通信的正在使用的洗衣机，这种情况图标跟常规图标是不同的,所以特殊处理了
            if (section == 2 && (device.deviceType == .pulsatorWasher || device.deviceType == .rollerWasher)) {
                usingCell.icon.image = UIImage(named: "device_washer_blue")
            }
            
            /// countDownDict 存储的是订单状态是进行中，设备是空闲时，显示启动失败的倒计时
            if section == 2, let countDown = countDownDict[device.id?.stringValue ?? ""] {
                /// 倒计时为0时，显示启动失败
                if countDown == 0 {

                    let failStr = "启动失败  "
                    let startStr = "立即启动"

                    let attString = NSMutableAttributedString(string: failStr + startStr)
                    attString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(rgb: 0x3399ff),
                                             NSAttributedString.Key.font : font_PingFangSC_Regular(14),
                                             NSAttributedString.Key.underlineStyle : 1],
                                            range: NSMakeRange(failStr.count, startStr.count))
                    usingCell.remainingTimeLabel.attributedText = attString

                } else {
                    /// 倒计时不为0时，显示启动中
                    usingCell.remainingTimeLabel.text = "启动中..."
                }
            } else {
                
                let startingStr = "正在启动"
                if section == 2 && device.residualTime == startingStr {
                    /// 特殊处理服务器放回 residualTime 为 "正在启动"
                    let attString = NSMutableAttributedString(string: startingStr)
                    attString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor_0x(0xff7733),
                                             NSAttributedString.Key.font: font_PingFangSC_Semibold(20)],
                                            range: NSMakeRange(0, startingStr.count))
                    usingCell.remainingTimeLabel.attributedText = attString
                } else {
                    let preStr = (section == 0) ? "支付剩余时长 " : (section == 1 ? "预约剩余时长 " : "剩余时长 ")
                    let timeStr = "\(device.residualTime ?? "0")分钟"
                    let attString = NSMutableAttributedString(string: preStr + timeStr)
                    attString.addAttributes([NSAttributedString.Key.foregroundColor: section == 2 ? UIColor_0x(0x333333) : UIColor_0x(0xff7733),
                                             NSAttributedString.Key.font: font_PingFangSC_Semibold(20)],
                                            range: NSMakeRange(preStr.count, timeStr.count))
                    usingCell.remainingTimeLabel.attributedText = attString
                }
            
                
            }
            
            //MARK: --------------- 暂时只让联系商家可点 ------------------
            usingCell.opearteBtn.isUserInteractionEnabled = (section == 2)
            usingCell.setOperationBtnStyle(isBlueStyle: section != 2)
            usingCell.opearteBtn.setTitle((section == 0) ? "立即支付" : (section == 1 ? "立即启动" : "联系商家"), for: .normal)
            usingCell.operateActionClourse = {
                action?((section == 0) ? .pay : (section == 1 ? .start : .contactTheMerchant))
            }

            cell = usingCell
            
        case 3:
            
            /// 推荐的设备cell
            
            if device.isEmpty {
                let  emptyCell = CommonEquipmentEmptyCell.create(tableView, indexPath) as! CommonEquipmentEmptyCell
                emptyCell.deviceNameLabel.text = device.showName!
                emptyCell.icon.image = UIImage(named: device.cellSmallIcon)
                cell = emptyCell

            } else {
                let  disabledCell = CommonEquipmentDisabledCell.create(tableView, indexPath) as! CommonEquipmentDisabledCell
                disabledCell.deviceNameLabel.text = device.showName
                disabledCell.icon.image = UIImage(named: device.cellSmallIcon)
                disabledCell.surplusTimeLabel.text = device.isOffLine ? "离线":"\(device.residualTime ?? "_")分钟"
                disabledCell.statusLabel.text = device.isOffLine ? "离线" : (device.washStatus == 3 ? "已预约" :"运行中")
                cell = disabledCell

            }
        default:
            cell = BaseTableViewCell()
        }
        
        return cell
    }
    
}

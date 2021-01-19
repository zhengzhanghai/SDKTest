//
//  EntrepreneurshipPlan.swift
//  WashingMachine
//
//  Created by Harious on 2018/2/2.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

class EntrepreneurshipPlan: ZZHModel {
    var commentCount: NSNumber?
    var commitTime: NSNumber?
    var content: String?
    var createTime: NSNumber?
    var expert: NSNumber?
    var failedReason: String?
    var goodCount: NSNumber?
    var icon: String?
    var id: NSNumber?
    var invest: NSNumber?
    var isGood: NSNumber?
    var isHide: NSNumber?
    var modifyTime: NSNumber?
    var name: String?
    var realName: String?
    var recommend: NSNumber?
    var schoolId : NSNumber?
    var schoolName: String?
    var status: NSNumber?
    var teamNumber: NSNumber?
    var userId: NSNumber?
    var views: NSNumber?
    
    /// 发布状态
    var publishStatus: EntrepreneurshipPlanExamineStatus {
        
        guard let status = self.status?.intValue else {
            return .unpublished
        }
        switch status {
        case 1: return .unpublished
        case 2: return .waitAuditished
        case 3: return .notPass
        case 4: return .passed
        default: return .unpublished
        }
    }
    
    var publishStatusStr : String  {
        
        switch publishStatus {
        case .unpublished:
            return "未发布"
        case .waitAuditished:
            return "等待审核"
        case .notPass:
            return "审核未通过"
        case .passed:
            return "已通过审核"
        }
    }
    
    var publishStatusExplainStr : String {
        switch publishStatus {
        case .unpublished:
            return ""
        case .waitAuditished:
            return ""
        case .notPass:
            return failedReason ?? ""
        case .passed:
            return ""
        }
    }
    
    /// 是否有专家点评
    var isExpertComment: Bool {
        return expert?.boolValue ?? false
    }
    
    /// 是否获得投资
    var isInvested: Bool {
        return invest?.boolValue ?? false
    }
    
    var teamNumberStr: String {
        guard let number = teamNumber else {
            return ""
        }
        switch number {
            
        case 1: return "1-3人"
        case 2: return "4-8人"
        case 3: return "9-15人"
        case 4: return "15人以上"
            
        default: return ""
        }
    }
}

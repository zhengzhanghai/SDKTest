//
//  ParticipaterDetailViewController.h
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseViewController.h"

@interface ParticipaterDetailViewController : BaseViewController
@property(nonatomic,copy) NSString *connectidID;//接单人id
@property(nonatomic,copy)NSString *orderSn;//当前订单编号
@property(nonatomic,copy)NSString *price;//报名者的报价

@end

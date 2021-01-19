//
//  DealDetailViewController.h
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/16.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseViewController.h"

@interface DealDetailViewController : BaseViewController
/* 这是一个共享页面，区分vc，
 * 0：我的派单-进行中-本人验收-订单详情+接单人详情
 * 1：我的接单-已报名-订单详情
 *
 */
@property(nonatomic,assign) NSInteger type;
@property(nonatomic,copy)NSString *orderSn;

@property(nonatomic, assign)BOOL canShensu;
@property(nonatomic, assign)BOOL isWork;
@property (nonatomic, assign)BOOL showBtn;

@end

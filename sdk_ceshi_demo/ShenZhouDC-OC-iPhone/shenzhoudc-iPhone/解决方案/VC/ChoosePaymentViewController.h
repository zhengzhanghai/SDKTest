//
//  ChoosePaymentViewController.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 17/1/17.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderModel.h"

@interface ChoosePaymentViewController : BaseViewController
/** 需要支付的方案ID */
@property (copy, nonatomic)   NSString *id;
/** 单价 */
@property (assign, nonatomic) float unitPrice;
/** 数量 */
@property (assign, nonatomic) NSInteger count;
@property (strong, nonatomic) OrderModel *orderModel;
@property(nonatomic,copy)NSString *appId;//支付时 appId
@property(nonatomic,copy)NSString *rechargeNo;//支付时  业务订单号
@property(nonatomic,copy)NSString *price;//用户填写的充值金额
@end

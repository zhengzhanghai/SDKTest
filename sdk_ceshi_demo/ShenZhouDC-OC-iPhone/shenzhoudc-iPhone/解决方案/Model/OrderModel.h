//
//  OrderModel.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 17/1/20.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseModel.h"

@interface OrderModel : BaseModel
@property (strong, nonatomic) NSNumber *id;
@property (copy, nonatomic)   NSString *orderSn;
@property (strong, nonatomic) NSNumber *itemType;
@property (strong, nonatomic) NSNumber *itemId;
@property (copy, nonatomic)   NSString *itemTitle;
@property (copy, nonatomic)   NSString *itemDesc;
@property (strong, nonatomic) NSNumber *orderStatus;
@property (strong, nonatomic) NSNumber *buyer;
@property (copy, nonatomic)   NSString *payer;
@property (copy, nonatomic)   NSString *payChannel;
@property (copy, nonatomic)   NSString *expireTime;
@property (copy, nonatomic)   NSString *amount;
@property (copy, nonatomic)   NSString *quantity;
@property (copy, nonatomic)   NSString *phone;
@property (copy, nonatomic)   NSString *memo;
@property (copy, nonatomic)   NSString *createTime;
@property (copy, nonatomic)   NSString *modifyTime;
@property (copy, nonatomic)   NSString *modifyBy;
@property (copy, nonatomic)   NSString *operator;

@end




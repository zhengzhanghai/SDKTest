//
//  MyRecievedModel.h
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/14.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseModel.h"

@interface MyRecievedModel : BaseModel

@property(nonatomic,strong)NSNumber *id;
@property(nonatomic,strong)NSNumber *userid;
@property(nonatomic,copy)NSString *orderSn;
@property(nonatomic,copy)NSString *acceptorname;
@property(nonatomic,strong)NSNumber *acceptormobile;
@property(nonatomic,strong)NSNumber *businessType;
@property(nonatomic,strong)NSNumber *technicalDirection;
@property(nonatomic,copy)NSString *orderTime;
@property(nonatomic,copy)NSString *serviceTime;
@property(nonatomic,strong)NSNumber *jobDays;
@property(nonatomic,strong)NSNumber *isovertime;
@property(nonatomic,copy)NSString *serviceContent;
@property(nonatomic,copy)NSString *unitType;
@property(nonatomic,copy)NSString *deliveryStandards;
@property(nonatomic,strong)NSNumber *orderPrice;
@property(nonatomic,copy)NSString *serviceAddress;
@property(nonatomic,strong)NSNumber *workType;
@property(nonatomic,strong)NSNumber *checkedByself;
@property(nonatomic,strong)NSNumber *serviceType;//状态值:0 已报名 1 待接单 2 进行中 3 已完工
@property(nonatomic,strong)NSNumber *confirmType;

- (BOOL)containsNilObject;
@end

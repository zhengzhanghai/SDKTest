//
//  MySendModel.h
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/14.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//我的派单列表数据

#import "BaseModel.h"

@interface MySendModel : BaseModel
@property(nonatomic,strong)NSNumber *id;
@property(nonatomic,copy)NSString *orderSn;
@property(nonatomic,copy)NSString *acceptorname;
@property(nonatomic,strong)NSNumber *acceptormobile;
@property(nonatomic,strong)NSNumber *businessType;
@property(nonatomic,strong)NSNumber *technicalDirection;
@property(nonatomic,copy)NSString *orderTime;
@property(nonatomic,strong)NSNumber *jobDays;
@property(nonatomic,strong)NSNumber *isovertime;
@property(nonatomic,copy)NSString *serviceContent;
@property(nonatomic,copy)NSString *unitType;
@property(nonatomic,copy)NSString *deliveryStandards;
@property(nonatomic,copy)NSString *serviceTime;
@property(nonatomic,strong)NSNumber *orderPrice;
@property(nonatomic,copy)NSString *serviceAddress;
@property(nonatomic,strong)NSNumber *userid;
@property(nonatomic,strong)NSNumber *workType;//状态：0未报名 1已报名 2进行中 3已完工
@property(nonatomic,strong)NSNumber *confirmType;//接单人是否完工 0 否 1是
@property(nonatomic,strong)NSNumber *checkedByself; //验收人是否是本人 0否 1是

@end

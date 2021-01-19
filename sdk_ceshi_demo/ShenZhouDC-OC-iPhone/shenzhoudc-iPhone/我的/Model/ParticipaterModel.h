//
//  ParticipaterModel.h
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseModel.h"

@interface ParticipaterModel : BaseModel
@property(nonatomic,copy)NSString *address;//地址
@property(nonatomic,copy)NSString *connectName;//接单人姓名
@property(nonatomic,copy)NSString *contentPhone;//接单人电话
@property(nonatomic,copy)NSString *registrationTime;//报名时间
@property(nonatomic,strong)NSNumber *id;//
@property(nonatomic,strong)NSNumber *overCount;//成单量
@property(nonatomic,strong)NSNumber *connectCount;//接单量
@property(nonatomic,strong)NSNumber *workingLife;//工作年限
@property(nonatomic,strong)NSNumber *rateType;//成单率
@property(nonatomic,strong)NSNumber *registrationNumber;//报名次数
@property(nonatomic,strong)NSNumber *price;//价格

@end

//
//  MyParticipatorModel.h
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/19.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseModel.h"

@interface MyParticipatorModel : BaseModel

//address = "\U5317\U4eac\U5e02\U5317\U4eac\U5e02\U4e1c\U57ce\U533a";
//connectName = "\U6ee1\U5e78\U798f";
//connectNumer = 1;
//connectid = 353;
//global = "5.00";
//id = 367;
//isSee = 0;
//orderSn = 20170500007;
//overType = 0;
//price = 20;
//ratetype = 100;
//registrationNumber = 3;
//registrationTime = "2017-05-19 16:00:15";
//workingLife = 100;

@property(nonatomic,strong)NSNumber *id;
@property(nonatomic,strong)NSNumber *overType;
@property(nonatomic,copy)NSString *orderSn;
@property(nonatomic,strong)NSNumber *connectid;
@property(nonatomic,copy)NSString *connectName;
@property(nonatomic,copy)NSString *workingLife;
@property(nonatomic,copy)NSString *address;
//@property(nonatomic,strong)NSNumber *sureType;
@property(nonatomic,strong)NSNumber *registrationNumber;
@property(nonatomic,strong)NSNumber *price;
//@property(nonatomic,copy)NSString *contentPhone;
@property(nonatomic,copy)NSString *registrationTime;
@property(nonatomic,strong)NSNumber *isSee;
@property(nonatomic,strong)NSNumber *ratetype;
//@property(nonatomic,strong)NSNumber *chooseType;
@property(nonatomic,strong)NSNumber *global;
@property(nonatomic,strong)NSNumber *connectNumer;
@end

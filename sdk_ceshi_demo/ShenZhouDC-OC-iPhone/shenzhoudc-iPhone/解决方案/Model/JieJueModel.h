//
//  JieJueModel.h
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/23.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonModel.h"
#import "BaseModel.h"

@interface JieJueModel : BaseModel

@property (nonatomic, strong) NSNumber         *id;
@property (nonatomic, strong) NSNumber         *categoryId;
@property (nonatomic, strong) NSNumber         *companyId;
@property (nonatomic, strong) NSNumber         *moneyId;
@property (nonatomic, copy)   NSString         *name;
@property (nonatomic, strong) NSNumber         *status;
@property (nonatomic, copy)   NSString         *icon;
@property (nonatomic, copy)   NSString         *unit;
@property (nonatomic, strong) NSNumber         *price;
@property (nonatomic, strong) NSNumber         *stock;
@property (nonatomic, copy)   NSString         *createTime;
@property (nonatomic, copy)   NSString         *modifyTime;
@property (nonatomic, strong) NSNumber         *orderCount;
@property (nonatomic, strong) NSNumber         *goodsCount;
@property (nonatomic, copy)   NSString         *companyName;
@property (nonatomic, copy)   NSString         *productNo;
@property (nonatomic, copy)   NSString         *cargoNo;
@property (nonatomic, strong) NSNumber         *recommend;
@property (nonatomic, copy)   NSString         *desp;
@property (nonatomic, copy)   NSString         *spec;
@property (nonatomic, copy)   NSString         *preview;

@property (nonatomic, copy)   NSString         *contentFile;//在线查看

//+ (instancetype)modelWithDictionary:(NSDictionary *)dict;
//- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end

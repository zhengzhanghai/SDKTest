//
//  PlanModel.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/8.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseModel.h"

@interface PlanModel : BaseModel
@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSNumber *orderCount;
@property (strong, nonatomic) NSNumber *goodsCount;
@property (copy, nonatomic)   NSString *name;
@property (copy, nonatomic)   NSString *coverImg;
@property (copy, nonatomic)   NSArray *industryName;
@end

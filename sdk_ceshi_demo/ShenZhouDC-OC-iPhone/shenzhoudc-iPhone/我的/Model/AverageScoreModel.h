//
//  AverageScoreModel.h
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/20.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//  接单人的业内平均分

#import "BaseModel.h"

@interface AverageScoreModel : BaseModel
@property(nonatomic,strong)NSNumber *cooperate;
@property(nonatomic,strong)NSNumber *global;
@property(nonatomic,strong)NSNumber *demandCompliance;
@end

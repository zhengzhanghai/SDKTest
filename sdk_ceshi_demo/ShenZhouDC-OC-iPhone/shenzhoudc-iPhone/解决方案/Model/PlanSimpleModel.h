//
//  PlanSimpleModel.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/9.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseModel.h"
#import "PKGProjectModel.h"

@interface PlanSimpleModel : BaseModel
@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSNumber *orderCount; // 成交量
@property (strong, nonatomic) NSNumber *goodsCount; // 点赞量
@property (strong, nonatomic) NSNumber *badsCount; // 点赞量
@property (strong, nonatomic) NSNumber *isCollent; //  是否收藏
@property (copy, nonatomic)   NSArray *coverImg;    // 轮播图
@property (copy, nonatomic)   NSArray *solutionPkgList;  // 交钥匙项目列表(最多五个)
@property (copy, nonatomic)   NSArray <PKGProjectModel *>*pkgModels;
@end

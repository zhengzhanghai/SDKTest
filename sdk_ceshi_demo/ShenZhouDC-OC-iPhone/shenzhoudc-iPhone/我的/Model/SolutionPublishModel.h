//
//  SolutionPublishModel.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/19.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseModel.h"

@interface SolutionPublishModel : BaseModel
@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSNumber *checkStatus;
@property (copy, nonatomic)   NSString *name;
@property (copy, nonatomic)   NSString *coverImg;
@property (copy, nonatomic)   NSArray <NSString *>*industryName;
@property (copy, nonatomic)   NSString *keyword;

@property (copy, nonatomic)   NSString *checkStatusStr;
@end

//
//  PlanDetailsModel.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/9.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseModel.h"


@interface PlanDetailsModel : BaseModel
@property (strong, nonatomic) NSNumber *id;
@property (copy, nonatomic)   NSString *name;
@property (copy, nonatomic)   NSString *successfulCase;
@property (copy, nonatomic)   NSString *awards;
@property (copy, nonatomic)   NSArray *industryName;
@property (copy, nonatomic)   NSString *keyword;
@end

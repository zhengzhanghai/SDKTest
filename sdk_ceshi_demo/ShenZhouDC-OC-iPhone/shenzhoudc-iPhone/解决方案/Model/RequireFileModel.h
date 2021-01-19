//
//  RequireFileModel.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 17/1/10.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseModel.h"

@interface RequireFileModel : BaseModel
@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSNumber *demandId;
@property (copy, nonatomic)   NSString *downUrl;
@property (strong, nonatomic) NSNumber *status;
@property (copy, nonatomic)   NSString *createTime;
@end

//
//  KeyProjectBuyerModel.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/26.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseModel.h"

@interface KeyProjectBuyerModel : BaseModel
@property (strong, nonatomic) NSNumber *buyerId;
@property (strong, nonatomic) NSNumber *type;
@property (copy, nonatomic)   NSString *buyerName;
@property (copy, nonatomic)   NSString *createTime;
@end

//
//  BuyPackageModel.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 17/1/19.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseModel.h"

@interface BuyPackageModel : BaseModel
@property (strong, nonatomic) NSNumber *id;
@property (copy, nonatomic)   NSString *name;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSNumber *partnerId;
@property (strong, nonatomic) NSNumber *userId;
@property (copy, nonatomic)   NSString *createTime;
@property (copy, nonatomic)   NSString *modifyTime;
@property (copy, nonatomic)   NSString *modifier;
@property (copy, nonatomic)   NSString *image;
@property (strong, nonatomic) NSNumber *solutionId;
@property (strong, nonatomic) NSNumber *status;
@property (strong, nonatomic) NSNumber *stock;

//@property (strong, nonatomic) NSNumber *partnerId;
//@property (copy, nonatomic)   NSNumber *partnerId;
@end

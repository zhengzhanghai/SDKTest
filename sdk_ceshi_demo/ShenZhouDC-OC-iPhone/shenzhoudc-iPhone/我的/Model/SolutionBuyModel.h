//
//  SolutionBuyModel.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/19.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseModel.h"

@interface SolutionBuyModel : BaseModel
@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSNumber *type;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSNumber *stauts;
@property (copy, nonatomic)   NSString *name;
@property (copy, nonatomic)   NSString *coverImg;
@property (copy, nonatomic)   NSString *orderTime;
@end

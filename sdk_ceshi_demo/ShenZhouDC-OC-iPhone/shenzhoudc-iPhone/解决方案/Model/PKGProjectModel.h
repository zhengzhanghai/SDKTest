//
//  PKGProjectModel.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/9.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseModel.h"

@interface PKGProjectModel : BaseModel
@property (strong, nonatomic) NSNumber *id;
@property (copy, nonatomic)   NSString *name;
@property (strong, nonatomic) NSNumber *price;
@end

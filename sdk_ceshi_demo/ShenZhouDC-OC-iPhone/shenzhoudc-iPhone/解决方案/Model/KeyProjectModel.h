//
//  KeyProjectModel.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/26.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseModel.h"

@interface KeyProjectModel : BaseModel
@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSNumber *price;
@property (copy, nonatomic)   NSString *name;
@property (copy, nonatomic)   NSString *desc;
@property (copy, nonatomic)   NSString *iconImg;
@property (copy, nonatomic)   NSArray *images;
@end

//
//  BaseModel.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface BaseModel : JSONModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

//
//  PlanSimpleModel.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/9.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "PlanSimpleModel.h"

@implementation PlanSimpleModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if ([super initWithDictionary:dict]) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:_solutionPkgList.count];
        for (NSUInteger i = 0; i < _solutionPkgList.count; i++) {
            [array addObject:[PKGProjectModel modelWithDictionary:_solutionPkgList[i]]];
        }
        _pkgModels = array;
    }
    return self;
}

@end

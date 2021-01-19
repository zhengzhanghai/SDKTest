//
//  FavoriteModel.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/7/20.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "FavoriteModel.h"

@implementation FavoriteModel

- (NSString *)goodsTypeName {
    //商品类型 1解决方案 2派单 3产品资源4交钥匙项目
    switch (_goosType.intValue) {
        case 1:
            return @"解决方案";
            break;
        case 2:
            return @"派单";
            break;
        case 3:
            return @"产品资源";
            break;
        case 4:
            return @"交钥匙项目";
            break;
    }
    return @"";
}

@end

//
//  ITServiceModel.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ITServiceModel.h"

@implementation ITServiceModel

//技术方向 1网络类 2安全 3服务器 4 开发 5软件 6储存 7其他
- (NSString *)getTechnicalDirectionString {
    switch (_technicalDirection.integerValue) {
        case 1:
            return @"网络类";
            break;
        case 2:
            return @"安全";
            break;
        case 3:
            return @"服务器";
            break;
        case 4:
            return @"开发";
            break;
        case 5:
            return @"软件";
            break;
        case 6:
            return @"储存";
            break;
    }
    return @"其他";
}

@end

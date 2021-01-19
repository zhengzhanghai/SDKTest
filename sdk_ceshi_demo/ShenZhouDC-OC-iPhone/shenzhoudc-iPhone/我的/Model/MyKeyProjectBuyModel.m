//
//  MyKeyProjectBuyModel.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/26.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "MyKeyProjectBuyModel.h"

@implementation MyKeyProjectBuyModel

- (NSString *)stasusString {
    switch (_status.integerValue) {
        case 0:
            return @"生效";
            break;
        case 1:
            return @"待接单";
            break;
        case 2:
            return @"请到PC端上传合同";
            break;
        case 3:
            return @"等待确认合同";
            break;
        case 4:
            return @"待付款";
            break;
        case 5:
            return @"付款成功等待平台确认";
            break;
        case 6:
            return @"待开工";
            break;
        case 7:
            return @"进行中";
            break;
        case 8:
            return @"已完工待验收";
            break;
        case 9:
            return @"等待平台转账";
        case 10:
            return @"完工";
            break;
    }
    return @"";
}


@end

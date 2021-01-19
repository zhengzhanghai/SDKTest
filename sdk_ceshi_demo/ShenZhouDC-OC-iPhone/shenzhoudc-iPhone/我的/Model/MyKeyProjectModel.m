//
//  MyKeyProjectModel.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/26.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "MyKeyProjectModel.h"

@implementation MyKeyProjectModel
//0 生效,1 待接单,2 等待上传合同 , 3 等待确认合同, 4 待付款, 5 付款成功等待平台确认 ,6 待开工,7 进行中, 8 完工
- (NSString *)stasusString {
    switch (_status.integerValue) {
        case -1:
            return @"无效";
            break;
        case 0:
            return @"生效";
            break;
        case 1:
            return @"待接单";
            break;
        case 2:
            return @"等待上传合同";
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
            return @"等待购买人验收";
            break;
        case 9:
            return @"验收完成等待平台转账";
            break;
        case 10:
            return @"完工";
            break;
    }
    return @"";
}

@end

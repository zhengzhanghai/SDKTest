//
//  SolutionPublishModel.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/19.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "SolutionPublishModel.h"

@implementation SolutionPublishModel

- (NSString *)checkStatusStr {
    switch (_checkStatus.intValue) {
        case -1: return @"未通过"; break;
        case 0: return @"未审核"; break;
        case 1: return @"待付款"; break;
        case 2: return @"待发布"; break;
        case 3: return @"已发布"; break;
        case 4: return @"已下架"; break;
        case 5: return @"待平台确认收款"; break;
        default: return @""; break;
    }
}

@end

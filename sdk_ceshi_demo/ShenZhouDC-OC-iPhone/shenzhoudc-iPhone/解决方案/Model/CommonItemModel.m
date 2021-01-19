//
//  CommonItemModel.m
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/23.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "CommonItemModel.h"

@implementation CommonItemModel
+ (instancetype)createModel:(NSDictionary *)dict andKeyWord:(NSString *)keyword {
    CommonItemModel *model = [[CommonItemModel alloc] init];
    if ([dict.allKeys containsObject:@"id"]) {
        model.itemId = [dict[@"id"] stringValue];
    }
    if ([dict.allKeys containsObject:@"name"]) {
        model.itemName = dict[@"name"];
    }
    model.keyWord = keyword;
    
    // 当id == -1011（自定义的）时，是全部，将id置未@""
    if ([model.itemId isEqualToString:@"-1011"]) {
        model.itemId = @"";
    }
    return model;
}
@end

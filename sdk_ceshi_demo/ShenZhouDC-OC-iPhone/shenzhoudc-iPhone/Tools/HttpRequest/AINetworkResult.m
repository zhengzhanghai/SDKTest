//
//  AINetworkResult.m
//  EWoCartoon
//
//  Created by Crauson on 16/5/1.
//  Copyright © 2016年 Moguilay. All rights reserved.
//

#import "AINetworkResult.h"

@implementation AINetworkResult
{
}

+ (AINetworkResult *)createWithDic:(NSDictionary *)dic
{
    AINetworkResult* data = [[AINetworkResult alloc] init];
    [data setSourceDic:dic];
    return data;
}

// 获取网络请求状态码
- (int)getCode
{
    if (_sourceDic != nil) {
        id data = [_sourceDic objectForKey:@"code"];
        if(data)
        {
            return [data intValue];
        }
    }
    return 0;
}
// 获取网络请求提示信息
- (NSString *)getMessage
{
    if (_sourceDic != nil) {
        NSString *msg = @"";
        msg = [_sourceDic objectForKey:@"msg"];
        if ([msg isEqualToString:@""] || msg == nil) {
            msg = [_sourceDic objectForKey:@"message"];
        }
        return msg;
    }
    return @"";
}
// 返回服务器处理是否成功
- (BOOL)isSucceed
{
    int code = [self getCode];
    if(code == 1000)
    {
        return YES;
    }else{
        return NO;
    }
}
- (id)getDataObj
{
    if (_sourceDic != nil) {
        if ([[_sourceDic allKeys] containsObject:@"data"])return [_sourceDic objectForKey:@"data"];
        return _sourceDic;
        
        
    }
    return nil;
}


@end

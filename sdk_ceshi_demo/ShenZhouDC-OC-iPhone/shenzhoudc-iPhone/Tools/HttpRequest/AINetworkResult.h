//
//  AINetworkResult.h
//  EWoCartoon
//
//  Created by Crauson on 16/5/1.
//  Copyright © 2016年 Moguilay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AINetworkResult : NSObject

@property(nonatomic, strong)NSDictionary *sourceDic;

+ (AINetworkResult *)createWithDic:(NSDictionary *)dic;

- (BOOL)isSucceed;

- (int)getCode;
- (NSString *)getMessage;
- (id)getDataObj;

@end

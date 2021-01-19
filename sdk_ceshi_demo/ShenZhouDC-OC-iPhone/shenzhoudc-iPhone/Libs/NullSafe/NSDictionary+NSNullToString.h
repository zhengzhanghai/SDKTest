//
//  NSDictionary+NSNullToString.h
//  TakeAway
//
//  Created by Moguilay on 15/8/20.
//  Copyright (c) 2015年 Moguilay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NSNullToString)
//类型识别:将所有的NSNull类型转化成@""
+(id)changeType:(id)myObj;

@end

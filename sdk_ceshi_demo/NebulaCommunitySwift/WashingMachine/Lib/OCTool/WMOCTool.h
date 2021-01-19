//
//  WMOCTool.h
//  WashingMachine
//
//  Created by 郑章海 on 2020/10/9.
//  Copyright © 2020 Eteclabeteclab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMOCTool : NSObject

+ (NSString *)getIPAddress:(BOOL)preferIPv4;

+ (NSDictionary *)getIPAddresses;

+ (NSString *)getIPAdressAuto;

@end


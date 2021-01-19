//
//  AppDelegate.h
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/22.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//
typedef void(^alipayResultBlock)(NSString *); ////将支付宝结果状态码传出


#import <UIKit/UIKit.h>

#define App_Delegate [AppDelegate shareAppDelegate]
#define AppDelegateWindow [[AppDelegate shareAppDelegate] window]
#define AppDelegateWindowRootController [[[AppDelegate shareAppDelegate] window] rootViewController]

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,copy) alipayResultBlock alipayBlock;

+ (instancetype)shareAppDelegate;

@end


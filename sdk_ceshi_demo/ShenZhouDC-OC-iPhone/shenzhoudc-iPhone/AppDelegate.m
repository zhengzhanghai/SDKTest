//
//  AppDelegate.m
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/22.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//


#import "AppDelegate.h"
#import "WXLoginShare.h"
#import <AlipaySDK/AlipaySDK.h>//Alipay
#import "RSADataSigner.h"//Alipay
#import "SZHomeViewController.h"
#import "BaseNaviViewController.h"
#import "UIDevice+XJDevice.h"
#import <TencentOpenAPI/TencentOAuth.h>


@interface AppDelegate ()
@property (nonatomic,strong)WXLoginShare *wXLoginShare;
//@property(nonatomic,copy) alipayResultBlock alipayBlock;
@end

@implementation AppDelegate

+ (instancetype)shareAppDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.wXLoginShare  = [WXLoginShare shareInstance];
    [self.wXLoginShare WXLoginShareRegisterApp];
    [self.wXLoginShare WXLoginShareMesg];

    [[TencentOAuth alloc] initWithAppId:@"1104063046" andDelegate:nil]; //注册
    
//    if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"]) {
//        
//        [UIDevice setOrientation:UIInterfaceOrientationLandscapeRight];
//        //如果当前设备是ipad，则加载iPad首页里的项目
//        SZHomeViewController *vc = [[SZHomeViewController alloc]init];
//        vc.view.frame = self.window.bounds;
//        BaseNaviViewController *navi = [[BaseNaviViewController alloc]initWithRootViewController:vc];
//        self.window.rootViewController = navi;
//        
//    }else if ([[[UIDevice currentDevice] model] isEqualToString:@"iPhone"]) {
//    
//    }
    
    //创建沙盒目录 存储数据
    if (![GlobleFunction FileExistAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/Library/Private Documents"]]) {
        [GlobleFunction CreateDictionary:[NSHomeDirectory() stringByAppendingFormat:@"/Library/Private Documents"]];
        
    }
    
    return YES;
}



- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([url.scheme isEqualToString:WXAPPID]) {
        id wXLoginShare = self.wXLoginShare;
        return  [WXApi handleOpenURL:url delegate:wXLoginShare];
    }else if([url.host isEqualToString:@"safepay"]) {
       [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
           NSLog(@"openURL result: %@",resultDic);
           NSString *resultStatus = resultDic[@"resultStatus"];
           NSLog(@"支付宝客户端返回的状态码--> ** %@",resultStatus);
           if (self.alipayBlock != nil) {
               self.alipayBlock(resultStatus);
           }
           
       }];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    id idwXLoginShare = self.wXLoginShare;
    return [WXApi handleOpenURL:url delegate:idwXLoginShare];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end

//
//  BaseViewController.h
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/23.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonMacro.h"
#import "AINetworkEngine.h"

// 加载列表数据方式
typedef NS_ENUM(NSInteger, LoadListWay) {
    LoadListWayDefault, //
    LoadListWayRefresh, //刷新列表
    LoadListWayMore // 加载更多
};

@interface BaseViewController : UIViewController

/** navigationBar */
@property (strong, nonatomic) UINavigationBar *naviBar;

/** 加载菊花计数+1，如果计数=1，展示加载菊花 */
- (void)loadingAddCountToView:(UIView *)view;
/** 加载菊花计数-1，如果计数=0，隐藏加载菊花 */
- (void)loadingSubtractCount;
/** 直接展示加载菊花 */
- (void)showLoadingToView:(UIView *)view;
/** 直接隐藏加载菊花 */
- (void)hiddenLoading;

/** 正确信息提示 */
- (void)showSuccess:(UIView *)view message:(NSString *)message afterHidden:(NSTimeInterval)time;
/** 错误信息提示 */
- (void)showError:(UIView *)view message:(NSString *)message afterHidden:(NSTimeInterval)time;

/** 导航退出控制器，并隐藏tabbar */
- (void)pushControllerHiddenTabbar:(UIViewController *)controller;
@end

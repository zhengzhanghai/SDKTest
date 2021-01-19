//
//  BaseViewController.m
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/23.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"

@interface BaseViewController ()

/** 加载菊花 */
@property (strong, nonatomic) MBProgressHUD *loadingView;
/** 加载菊花引用计数 */
@property (assign,nonatomic) NSInteger loadingCount;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavationBackItem];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-60, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
}

- (BOOL)shouldAutorotate {
    return false;
}

- (UINavigationBar *)naviBar {
    return self.navigationController.navigationBar;
}

- (void)loadingAddCountToView:(UIView *)view {
    self.loadingCount++;
    if (self.loadingCount == 1) {
        if (!self.loadingView) {
            self.loadingView = [MBProgressHUD showHUDAddedTo:view animated:YES];
            self.loadingView.removeFromSuperViewOnHide = YES;
            self.loadingView.label.text = @"加载中...";
        }
    }
}

- (void)naviBack {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)customNavationBackItem {
    if (self.navigationController && self.navigationController.viewControllers.count >= 2) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 0, 30, 30);
        [backBtn setImage:[UIImage imageNamed:@"icon_return"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(naviBack) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    }
}

- (void)loadingSubtractCount {
    self.loadingCount--;
    if (self.loadingCount == 0) {
        [self.loadingView hideAnimated:YES];
        self.loadingView = nil;
    } else if (self.loadingCount < 0) {
        self.loadingCount = 0;
    }
}

- (void)showLoadingToView:(UIView *)view {
    if (!self.loadingView) {
        self.loadingView = [MBProgressHUD showHUDAddedTo:view animated:YES];
        self.loadingView.removeFromSuperViewOnHide = YES;
        self.loadingView.label.text = @"";
    }
}

- (void)hiddenLoading {
    [self.loadingView hideAnimated:YES];
    self.loadingView = nil;
    self.loadingCount = 0;
}


- (void)showSuccess:(UIView *)view message:(NSString *)message afterHidden:(NSTimeInterval)time {
    MBProgressHUD *success = [MBProgressHUD showHUDAddedTo:view animated:YES];
    success.label.text = message;
    success.label.numberOfLines = 0;
    success.removeFromSuperViewOnHide = YES;
    success.mode = MBProgressHUDModeText;
    success.userInteractionEnabled = false;
    [success hideAnimated:YES afterDelay:time];
}

- (void)showError:(UIView *)view message:(NSString *)message afterHidden:(NSTimeInterval)time {
    MBProgressHUD *error = [MBProgressHUD showHUDAddedTo:view animated:YES];
    error.label.text = message;
    error.label.numberOfLines = 0;
    error.removeFromSuperViewOnHide = YES;
    error.mode = MBProgressHUDModeText;
    error.userInteractionEnabled = false;
    [error hideAnimated:YES afterDelay:time];
}

- (void)pushControllerHiddenTabbar:(UIViewController *)controller {
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

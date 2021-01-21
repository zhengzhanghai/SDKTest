//
//  SZHomeViewController.m
//  shenzhoudc-iPhone
//
//  Created by 郑章海 on 17/2/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "SZHomeViewController.h"
#import "MenuView.h"
#import "HomeBottomView.h"
#import "ADSModel.h"

#import "ProductViewController.h"
#import "PaiGongViewController.h"
#import "SZJieJueViewController.h"
#import "QuoteToolViewController.h"
#import "VideoCenterViewController.h"
#define BottomHeight 67
#define MenuWidth SCREEN_WIDTH*0.3

@interface SZHomeViewController ()

@property (strong, nonatomic) MenuView *menuView;
@property (strong, nonatomic) HomeBottomView *bottomView;
@property (strong, nonatomic) ProductViewController *productVC;
@property (strong, nonatomic) PaiGongViewController *paiGongVC;
@property (strong, nonatomic) SZJieJueViewController *jieJueVC;
@property (strong, nonatomic) QuoteToolViewController *quoteToolVC;
@property (strong, nonatomic) VideoCenterViewController *videoVC;

@end

@implementation SZHomeViewController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSubView];
 

}
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}
#pragma mark - - orientation

//设置presentation方式展示的屏幕方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
}

- (void)addSubView {
    [self.view addSubview:self.menuView];
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(MenuWidth);
        make.height.mas_equalTo(SCREEN_HEIGHT-BottomHeight);
    }];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(BottomHeight);
    }];
    
    [self addChildVCAndView:self.productVC];
}

#pragma mark懒加载
- (MenuView *)menuView {
    if (!_menuView) {
        _menuView = [[MenuView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        __weak SZHomeViewController *weakSelf = self;
        _menuView.selectBlock = ^(NSInteger index) {
            [weakSelf menuChange:index];
        };
    }
    return _menuView;
}

- (void)menuChange:(NSInteger)index {
    switch (index) {
        case 0:
        {
            [self.view bringSubviewToFront:self.productVC.view];
        }
            break;
        case 1:
        {
            if (!_paiGongVC) {
                [self addChildVCAndView:self.paiGongVC];
            } else {
                [self.view bringSubviewToFront:self.paiGongVC.view];
            }
        }
            break;
        case 2:
        {
            if (!_jieJueVC) {
                [self addChildVCAndView:self.jieJueVC];
            } else {
                [self.view bringSubviewToFront:self.jieJueVC.view];
            }
        }
            break;
        case 3:
        {
            if (!_quoteToolVC) {
                [self addChildVCAndView:self.quoteToolVC];
            } else {
                [self.view bringSubviewToFront:self.quoteToolVC.view];
            }
        }
            break;
        case 4:
        {
            if (!_videoVC) {
                [self addChildVCAndView:self.videoVC];
            } else {
                [self.view bringSubviewToFront:self.videoVC.view];
            }
        }
            break;
        case 5:
        {
            
        }
            break;
        default:
            break;
    }
}

// 添加子控制器
- (void)addChildVCAndView:(UIViewController *)vc {
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    [vc didMoveToParentViewController:self];
    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(MenuWidth);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH-MenuWidth);
        make.bottom.equalTo(self.bottomView.mas_top).offset(0);
    }];

}

#pragma mark 底部栏 懒加载
- (HomeBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[HomeBottomView alloc] init];
        _bottomView.refreshBlock = ^() {
            
        };
        _bottomView.profileBlock = ^() {
            
        };
    }
    return _bottomView;
}

- (ProductViewController *)productVC {
    if (!_productVC) {
        _productVC = [[ProductViewController alloc] init];
    }
    return _productVC;
}

- (PaiGongViewController *)paiGongVC {
    if (!_paiGongVC) {
        _paiGongVC = [[PaiGongViewController alloc] init];
    }
    return _paiGongVC;
}

- (SZJieJueViewController *)jieJueVC {
    if (!_jieJueVC) {
        _jieJueVC = [[SZJieJueViewController alloc] init];
    }
    return _jieJueVC;
}

- (QuoteToolViewController *)quoteToolVC {
    if (!_quoteToolVC) {
        _quoteToolVC = [[QuoteToolViewController alloc] init];
    }
    return _quoteToolVC;
}

- (VideoCenterViewController *)videoVC {
    if (!_videoVC) {
        _videoVC = [[VideoCenterViewController alloc] init];
    }
    return _videoVC;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end

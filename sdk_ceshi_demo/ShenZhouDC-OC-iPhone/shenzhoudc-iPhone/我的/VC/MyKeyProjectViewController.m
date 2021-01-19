//
//  MyKeyProjectViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/26.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "MyKeyProjectViewController.h"
#import "MykeyProjectHeaderView.h"
#import "MyKeyProjectTableViewController.h"
#import "PlatformAccontView.h"
#import "AppDelegate.h"
#import "MeChooseMenuView.h"

#define HEADER_HEIGHT (IS_IPAD ? 55 : 45)

@interface MyKeyProjectViewController ()
@property (strong, nonatomic) MykeyProjectHeaderView *headerView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIButton *platformAccountBtn;
@property (strong, nonatomic) PlatformAccontView *accountView;

@property (strong, nonatomic) MyKeyProjectTableViewController *buyVC;
@property (strong, nonatomic) MyKeyProjectTableViewController *publishVC;
@end

@implementation MyKeyProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的交钥匙项目";
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
    [self addPlatformAccountBtn];
    
    _buyVC = [self createAndAddChildVC:KeyProjectTableTypeBuy];
}

- (void)addPlatformAccountBtn {
    _platformAccountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _platformAccountBtn.frame = CGRectMake(0, 0, 75, 20);
    _platformAccountBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_platformAccountBtn setTitle:@"平台账户" forState:UIControlStateNormal];
    [_platformAccountBtn setTitleColor:UIColorFromRGB(0x4b4b4b) forState:UIControlStateNormal];
    [_platformAccountBtn addTarget:self action:@selector(clickPlatformAccountBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_platformAccountBtn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)clickPlatformAccountBtn:(UIButton *)btn {
    [((AppDelegate *)([UIApplication sharedApplication].delegate)).window.rootViewController.view addSubview:self.accountView];
    [self.accountView showAnimation];
}

- (PlatformAccontView *)accountView {
    if (!_accountView) {
        _accountView = [[PlatformAccontView alloc] init];
    }
    return _accountView;
}

- (void)makeUI {
    MeChooseMenuView *menuView = [[MeChooseMenuView alloc] initWithFrame:CGRectMake(0, TOPBARHEIGHT, SCREEN_WIDTH, HEADER_HEIGHT) titles:@[@"已购买", @"已发布"]];
    [self.view addSubview:menuView];
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(TOPBARHEIGHT);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    menuView.clickItemBlock = ^(NSUInteger index) {
        [self exchangeContentView:index];
    };
    
//    _headerView = [[MykeyProjectHeaderView alloc] initWithFrame:CGRectMake(0, TOPBARHEIGHT, SCREEN_WIDTH, HEADER_HEIGHT)];
//    [self.view addSubview:_headerView];
//    __weak typeof(self) weakSelf = self;
//    _headerView.clickItemBlock = ^(NSInteger index) {
//        [weakSelf exchangeContentView:index];
//    };
    [self.view addSubview:self.scrollView];
}

- (void)exchangeContentView:(NSInteger)index {
    CGFloat offectX = 0;
    if (index == 1) {
        offectX = SCREEN_WIDTH;
        if (!_publishVC) {
            _publishVC = [self createAndAddChildVC:KeyProjectTableTypePublish];
        }
    }
    [UIView animateWithDuration:0.2 animations:^{
        _scrollView.contentOffset = CGPointMake(offectX, 0);
    }];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TOPBARHEIGHT+HEADER_HEIGHT, SCREEN_WIDTH, CONTENTHEIGHT_NOTOP-HEADER_HEIGHT)];
        _scrollView.scrollEnabled = false;
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, _scrollView.height);
    }
    return _scrollView;
}

- (MyKeyProjectTableViewController *)createAndAddChildVC:(KeyProjectTableType)type {
    MyKeyProjectTableViewController *vc = [[MyKeyProjectTableViewController alloc] init];
    vc.type = type;
    [self addChildViewController:vc];
    [vc didMoveToParentViewController:self];
    if (type == KeyProjectTableTypePublish) {
        vc.view.frame = CGRectMake(SCREEN_WIDTH, 0, _scrollView.width, _scrollView.height);
    } else {
        vc.view.frame = CGRectMake(0, 0, _scrollView.width, _scrollView.height);
    }
    [_scrollView addSubview:vc.view];
    return vc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

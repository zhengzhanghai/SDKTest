//
//  WaitReveiceOrderViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/26.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "WaitReveiceOrderViewController.h"
#import "KeyProjectDetailsViewController.h"
#import "KeyProjectBuyListViewController.h"

@interface WaitReveiceOrderViewController ()
@property (strong, nonatomic) UISegmentedControl *segmentedControl;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) KeyProjectDetailsViewController *detailsVC;
@property (strong, nonatomic) KeyProjectBuyListViewController *buyerVC;
@end

@implementation WaitReveiceOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.buyerVC.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.segmentedControl];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.segmentedControl removeFromSuperview];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TOPBARHEIGHT, SCREEN_WIDTH, CONTENTHEIGHT_NOTOP)];
        _scrollView.scrollEnabled = false;
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, _scrollView.height);
    }
    return _scrollView;
}

- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"购买人列表", @"交钥匙项目详情"]];
        _segmentedControl.frame = CGRectMake(100, 10, 200, 30);
        _segmentedControl.centerX = SCREEN_WIDTH/2;
        _segmentedControl.tintColor = [UIColor redColor];
        [_segmentedControl addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
        _segmentedControl.selectedSegmentIndex = 0;
    }
    return _segmentedControl;
}

- (void)segmentChange:(UISegmentedControl *)segment {
    if (segment.selectedSegmentIndex == 0) {
        [UIView animateWithDuration:0.2 animations:^{
            _scrollView.contentOffset = CGPointMake(0, 0);
        }];
    } else if (segment.selectedSegmentIndex == 1) {
        if (!_detailsVC) {
            [_scrollView addSubview:self.detailsVC.view];
        }
        [UIView animateWithDuration:0.2 animations:^{
            _scrollView.contentOffset = CGPointMake(_scrollView.width, 0);
        }];
    }
}

- (KeyProjectDetailsViewController *)detailsVC {
    if (!_detailsVC) {
        _detailsVC = [[KeyProjectDetailsViewController alloc] init];
        _detailsVC.keyProjectId = _pkgId;
        _detailsVC.view.frame = CGRectMake(self.scrollView.width, 0, self.scrollView.width, self.scrollView.height);
        [self addChildViewController:_detailsVC];
        [_detailsVC didMoveToParentViewController:self];
    }
    return  _detailsVC;
}

- (KeyProjectBuyListViewController *)buyerVC {
    if (!_buyerVC) {
        _buyerVC = [[KeyProjectBuyListViewController alloc] init];
        _buyerVC.pkgId = _pkgId;
        _buyerVC.view.frame = CGRectMake(0, 0, self.scrollView.width, self.scrollView.height);
        [self addChildViewController:_buyerVC];
        [_buyerVC didMoveToParentViewController:self];
    }
    return _buyerVC;
}

@end

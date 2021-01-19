//
//  PaiViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/5/31.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "PaiViewController.h"
#import "PaiGongHeaderView.h"
#import "ITServiceViewController.h"

@interface PaiViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) PaiGongHeaderView *headerView;
@property (strong, nonatomic) NSMutableDictionary *subControllerDict;
@property (strong, nonatomic) UIScrollView *scrollView;
@end

@implementation PaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    _subControllerDict = [NSMutableDictionary dictionary];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.headerView];
    [self createSubController:0];
}

- (PaiGongHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[PaiGongHeaderView alloc] initWithFrame:CGRectMake(0.f, NAVBARHEIGHT+STATUSBARHEIGHT, SCREEN_WIDTH, 50.f)
                                                        titles:[self headerTitles]];
        __weak typeof(self) weakSelf = self;
        _headerView.clickTitleBlock = ^(NSInteger index) {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf exchangeSubController:index];
            strongSelf.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH*index, 0);
        };
    }
    return _headerView;
}

- (NSArray *)headerTitles {
    return @[@"服务类型", @"技术方向", @"服务地点"];
}

// 切换子控制器
- (void)exchangeSubController:(NSInteger)index {
    [self createSubController:index];
}

// 创建子控制器（不存在才创建）
- (void)createSubController:(NSInteger)index {
    if (![_subControllerDict.allKeys containsObject:[NSString stringWithFormat:@"%zd", index]]) {
        ITServiceViewController *vc = [[ITServiceViewController alloc] init];
        vc.view.frame = CGRectMake(_scrollView.width*index, 0.f, _scrollView.width, _scrollView.height);
        [_scrollView addSubview:vc.view];
        [self addChildViewController:vc];
        [vc didMoveToParentViewController:self];
        [_subControllerDict setObject:vc forKey:[NSString stringWithFormat:@"%zd", index]];
    }
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f,
                                                                     NAVBARHEIGHT+STATUSBARHEIGHT+50.f,
                                                                     SCREEN_WIDTH,
                                                                     SCREEN_HEIGHT-50.f-TABBARHEIGHT-NAVBARHEIGHT-STATUSBARHEIGHT)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = true;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.contentSize = CGSizeMake([[self headerTitles] count]*SCREEN_WIDTH, 0);
    }
    return _scrollView;
}

#pragma mark ------- UIScrollViewDelegate ------ 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self createSubController:(NSInteger)(_scrollView.contentOffset.x/SCREEN_WIDTH)];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _headerView.currentIndex = (NSInteger)round(scrollView.contentOffset.x/scrollView.width);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

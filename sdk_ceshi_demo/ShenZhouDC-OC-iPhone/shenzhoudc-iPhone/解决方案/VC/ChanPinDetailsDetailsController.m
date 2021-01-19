//
//  ChanPinDetailsDetailsController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/29.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "ChanPinDetailsDetailsController.h"
#import <WebKit/WebKit.h>
#import "CanShuTableViewCell.h"

#define TOP_Menu_Height 50

@interface ChanPinDetailsDetailsController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UIScrollView *scrollview;
@property (nonatomic, strong)UIButton *detailsBtn;
@property (nonatomic, strong)UIButton *canShuBtn;
@property (nonatomic, strong)UIButton *topSelectedBtn;
//图文详情视图
@property (nonatomic, strong)WKWebView *webView;
//参数列表视图
@property (nonatomic, strong)UITableView *tableView;

@end

@implementation ChanPinDetailsDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSubView];
    [self refresh];
}


// 加载部分模拟数据
- (void)refresh {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:PDFDEMOURL]]];
}

- (void)addSubView {
    [self addTopView];
    [self.view addSubview:self.scrollview];
    [self.scrollview addSubview:self.webView];
}

// 添加图文详情、产品参数视图
- (void)addTopView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TOP_Menu_Height)];
    [self.view addSubview:topView];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, topView.width, 1)];
    [topView addSubview:topLine];
    topLine.backgroundColor = UIColorFromRGB(0xF8F8F8);
    
    _detailsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [topView addSubview:_detailsBtn];
    _detailsBtn.frame = CGRectMake(0, 0, 60, 22);
    _detailsBtn.centerX = SCREEN_WIDTH/4;
    _detailsBtn.centerY = topView.height/2;
    [_detailsBtn setTitle:@"图文详情" forState:UIControlStateNormal];
    _detailsBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_detailsBtn setTitleColor:UIColorFromRGB(0x484848) forState:UIControlStateNormal];
    [_detailsBtn setTitleColor:UIColorFromRGB(0xD71629) forState:UIControlStateSelected];
    [_detailsBtn addTarget:self action:@selector(clickTopBtn:) forControlEvents:UIControlEventTouchUpInside];
    _detailsBtn.selected = YES;
    self.topSelectedBtn = _detailsBtn;
    
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(topView.width/2-1, 14, 2, 22)];
    [topView addSubview:sepLine];
    sepLine.backgroundColor = UIColorFromRGB(0xF8F8F8);
    
    _canShuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [topView addSubview:_canShuBtn];
    _canShuBtn.frame = CGRectMake(0, 0, 60, 22);
    _canShuBtn.centerX = SCREEN_WIDTH*0.75;
    _canShuBtn.centerY = topView.height/2;
    [_canShuBtn setTitle:@"产品参数" forState:UIControlStateNormal];
    _canShuBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_canShuBtn setTitleColor:UIColorFromRGB(0x484848) forState:UIControlStateNormal];
    [_canShuBtn setTitleColor:UIColorFromRGB(0xD71629) forState:UIControlStateSelected];
    [_canShuBtn addTarget:self action:@selector(clickTopBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, TOP_Menu_Height-1, topView.width, 1)];
    [topView addSubview:bottomLine];
    topLine.backgroundColor = UIColorFromRGB(0xF8F8F8);
}

#pragma mark 点击图文详情、产品参数
- (void)clickTopBtn:(UIButton *)btn {
    if (self.topSelectedBtn == btn) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        if (btn == _detailsBtn) {
            self.scrollview.contentOffset = CGPointMake(0, 0);
        } else if (btn == _canShuBtn) {
            self.scrollview.contentOffset = CGPointMake(self.scrollview.width, 0);
            if (!_tableView) {
                [self.scrollview addSubview:self.tableView];
            }
        }
    }];
    btn.selected = YES;
    self.topSelectedBtn.selected = NO;
    self.topSelectedBtn = btn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma 懒加载视图
- (UIScrollView *)scrollview {
    if (!_scrollview) {
        _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TOP_Menu_Height, SCREEN_WIDTH, SCREEN_HEIGHT-TOP_Menu_Height-NAVBARHEIGHT-STATUSBARHEIGHT)];
        _scrollview.contentSize = CGSizeMake(_scrollview.width*2, _scrollview.height);
        _scrollview.backgroundColor = [UIColor whiteColor];
        _scrollview.scrollEnabled = NO;
    }
    return _scrollview;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               self.scrollview.width,
                                                               self.scrollview.height)];
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.scrollview.width,
                                                                   0,
                                                                   self.scrollview.width,
                                                                   self.scrollview.height)
                                                  style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = UIColorFromRGB(0xEAEAEA);
        _tableView.estimatedRowHeight = 45;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

#pragma mark: ______ tableView  Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CanShuTableViewCell *cell = [CanShuTableViewCell cell:tableView indexPath:indexPath];
    if (indexPath.row == 0) {
        [cell refreshCell:@"处理器" content:@"英特尔® 酷睿™ i7-6700K"];
    } else if (indexPath.row == 1) {
        [cell refreshCell:@"操作系统" content:@"Windows 10 (TH2)"];
    } else {
        [cell refreshCell:@"显卡" content:@"NVIDIA GTX 980Ti"];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColorFromRGB(0xEAEAEA);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

@end

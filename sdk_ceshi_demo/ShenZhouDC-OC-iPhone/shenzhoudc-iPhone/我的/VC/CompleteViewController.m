//
//  CompleteViewController.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "CompleteViewController.h"
#import <WebKit/WebKit.h>

@interface CompleteViewController ()
@property(nonatomic,strong)WKWebView *webView;
@end

@implementation CompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.title = @"评价详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
    [self loadData];
}

- (void)makeUI {
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:[ WKWebViewConfiguration new]];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.top.equalTo(self.view.mas_top).with.offset(NAVIGATION_BAR_HEIGHT+STATUSBARHEIGHT);
        make.right.mas_equalTo(-10.f);
        make.bottom.mas_equalTo(-10.f);
    }];
}
- (void)loadData {
    if (self.type == 0) {
        
    }else if(self.type == 1) {
        
    }
}
@end

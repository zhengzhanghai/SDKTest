//
//  BaseWebViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/5.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseWebViewController.h"

@interface BaseWebViewController ()

@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    [self makeWebView];
}

- (void)makeWebView {
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0.f, NAVBARHEIGHT+STATUSBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVBARHEIGHT-STATUSBARHEIGHT)];
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_loadURLString]]];
}

- (BOOL)shouldAutorotate {
    return true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

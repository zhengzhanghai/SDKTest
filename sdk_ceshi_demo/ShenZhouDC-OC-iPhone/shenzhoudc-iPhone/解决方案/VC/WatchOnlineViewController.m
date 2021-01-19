//
//  WatchOnlineViewController.m
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/24.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "WatchOnlineViewController.h"
#import <WebKit/WebKit.h>

@interface WatchOnlineViewController ()
@property (nonatomic, strong) WKWebView         *webView;
@end

@implementation WatchOnlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"完整版方案";
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) configuration:[WKWebViewConfiguration new]];
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end

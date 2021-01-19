//
//  SuccessCaseDetailWebViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/29.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "SuccessCaseDetailWebViewController.h"
#import <WebKit/WebKit.h>

@interface SuccessCaseDetailWebViewController ()

@property (nonatomic, strong) WKWebView         *webView;

@end

@implementation SuccessCaseDetailWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

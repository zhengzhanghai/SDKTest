//
//  ProtocolViewController.m
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 16/12/29.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "ProtocolViewController.h"
#import <WebKit/WebKit.h>

@interface ProtocolViewController ()

@end

@implementation ProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务协议";
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) configuration:[WKWebViewConfiguration new]];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [self.view addSubview:webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

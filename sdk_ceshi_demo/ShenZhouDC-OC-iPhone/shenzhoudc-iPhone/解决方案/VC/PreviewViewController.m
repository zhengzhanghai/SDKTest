//
//  PreviewViewController.m
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/24.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "PreviewViewController.h"
#import <WebKit/WebKit.h>

@interface PreviewViewController ()
@property (nonatomic, strong) WKWebView         *webView;
@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"简版方案预览";
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
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

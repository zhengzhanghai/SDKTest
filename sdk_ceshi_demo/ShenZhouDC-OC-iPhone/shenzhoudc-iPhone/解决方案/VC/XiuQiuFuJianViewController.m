//
//  XiuQiuFuJianViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 17/1/9.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "XiuQiuFuJianViewController.h"
#import <WebKit/WebKit.h>

@interface XiuQiuFuJianViewController ()
@property (strong, nonatomic) WKWebView *webView;
@end

@implementation XiuQiuFuJianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"附件%@", self.id];
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

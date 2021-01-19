//
//  FileDetailViewController.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/3/22.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "FileDetailViewController.h"
#import <WebKit/WebKit.h>

@interface FileDetailViewController ()<WKNavigationDelegate>
@property(nonatomic,strong) WKWebView *webView;
@end

@implementation FileDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"文件预览";//self.model.fileName;
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) configuration:[WKWebViewConfiguration new]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    [self.view addSubview:self.webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

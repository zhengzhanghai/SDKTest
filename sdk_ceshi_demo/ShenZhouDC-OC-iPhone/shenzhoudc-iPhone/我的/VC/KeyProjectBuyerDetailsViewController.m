//
//  KeyProjectBuyerDetailsViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/27.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "KeyProjectBuyerDetailsViewController.h"
#import <WebKit/WebKit.h>

#define BOTTOM_HEIGHT 50

@interface KeyProjectBuyerDetailsViewController ()<WKNavigationDelegate>
@property (strong, nonatomic) UIButton *sureReveiceOrderBtn;
@end

@implementation KeyProjectBuyerDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"购买者详情";
    [self makeWebView];
}

- (void)makeWebView {
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-BOTTOM_HEIGHT)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?id=%@", DOMAIN_NAME_H5, H5_USER_INFO, _buyerModel.buyerId.stringValue]]]];
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
}

- (void)makeSureReveiceOrderBtn {
    _sureReveiceOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureReveiceOrderBtn.frame = CGRectMake(0, SCREEN_HEIGHT-BOTTOM_HEIGHT, SCREEN_WIDTH, BOTTOM_HEIGHT);
    _sureReveiceOrderBtn.backgroundColor = [UIColor redColor];
    [_sureReveiceOrderBtn setTitle:@"确认接单" forState:UIControlStateNormal];
    [_sureReveiceOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sureReveiceOrderBtn addTarget:self action:@selector(clickSureReveiceOrderBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sureReveiceOrderBtn];
}

- (void)clickSureReveiceOrderBtn {
    NSString *url = API_POST_KEY_PROJECT_SURE_RECEIVE_ORDER;
    NSDictionary *dict = @{@"userId": [UserModel sharedModel].userId,
                           @"buyerId": _buyerModel.buyerId.stringValue,
                           @"pakId": _pkgId};
    [[AINetworkEngine sharedClient] postWithApi:url parameters:dict CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            [self showSuccess:self.view message:result.getMessage afterHidden:1.5];
            if (result.isSucceed) {
            }
        } else {
            [self showError:self.view message:@"请求失败" afterHidden:1.5];
        }
        [self hiddenLoading];
    }];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self makeSureReveiceOrderBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

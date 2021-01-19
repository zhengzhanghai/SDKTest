//
//  CanPinDetailsCanShuViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 17/1/6.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "CanPinDetailsCanShuViewController.h"
#import "JieJueModel.h"
#import <WebKit/WebKit.h>

@interface CanPinDetailsCanShuViewController ()
@property (strong, nonatomic) WKWebView *webView;
@end

@implementation CanPinDetailsCanShuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeWebView];
    [self loadDetails];
}

- (void)makeWebView {
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-STATUSBARHEIGHT-NAVBARHEIGHT)];
    _webView.backgroundColor = [UIColor whiteColor];
    NSString *jsString = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '60%'";
    [_webView evaluateJavaScript:jsString completionHandler:nil];
    [self.view addSubview:_webView];
}

// 获取解决方案详情
- (void)loadDetails {
    NSString *url = [NSString stringWithFormat:@"%@%@", API_GET_PRODUCT_DETAILS, self.id];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            if ([result isSucceed]) {
                NSDictionary *data = [result getDataObj];
                JieJueModel *model = [JieJueModel modelWithDictionary:data];
                [self.webView loadHTMLString:model.spec baseURL:nil];
            }
        } else {
            NSLog(@"—————————请求失败—————————");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

//
//  JieJueDetailCanShuViewController.m
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/24.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "JieJueDetailCanShuViewController.h"
#import "CanShuTableViewCell.h"
#import "JieJueModel.h"
#import <WebKit/WebKit.h>

@interface JieJueDetailCanShuViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) WKWebView *webView;
@end

@implementation JieJueDetailCanShuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self makeTable];
    [self makeWebView];
    [self loadDetails];
}

- (void)makeWebView {
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-STATUSBARHEIGHT-NAVBARHEIGHT) configuration:[WKWebViewConfiguration new]];
    _webView.backgroundColor = [UIColor whiteColor];
    NSString *jsString = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '60%'";
    [_webView evaluateJavaScript:jsString completionHandler:nil];
    [self.view addSubview:_webView];
}

- (void)makeTable {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-STATUSBARHEIGHT-NAVBARHEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = UIColorFromRGB(0xEAEAEA);
    _tableView.estimatedRowHeight = 45;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.tableFooterView = [[UIView alloc] init];
    
}

// 获取解决方案详情
- (void)loadDetails {
    NSString *url = [NSString stringWithFormat:@"%@%@%@", DOMAIN_NAME,API_GET_SLOUTION_DETAILS, self.id];
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


#pragma mark: ______ tableView  Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CanShuTableViewCell *cell = [CanShuTableViewCell cell:tableView indexPath:indexPath];
    if (indexPath.row == 0) {
        [cell refreshCell:@"处理器" content:@"英特尔® 酷睿™ i7-6700K"];
    } else if (indexPath.row == 1) {
        [cell refreshCell:@"操作系统" content:@"Windows 10 (TH2)"];
    } else {
        [cell refreshCell:@"显卡" content:@"NVIDIA GTX 980Ti"];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColorFromRGB(0xEAEAEA);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

//
//  JieJueSolutionDetailsWEBController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/9.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "JieJueSolutionDetailsWEBController.h"
#import "PlanDetailsModel.h"
#import "SolutionDetailsContentView.h"

@interface JieJueSolutionDetailsWEBController ()
@end

@implementation JieJueSolutionDetailsWEBController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    [self loadDetails];
}

// 获取解决方案详细信息
- (void)loadDetails {
    NSString *url = [NSString stringWithFormat:@"%@%@%@",DOMAIN_NAME, API_GET_SLOUTION_DETAILS_NEW, self.id];
    [self loadingAddCountToView:self.view];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            if ([result isSucceed]) {
                NSDictionary *data = [result getDataObj];
                PlanDetailsModel *model = [PlanDetailsModel modelWithDictionary:data];
                [self makeContentView:model];
            }
        } else {
            NSLog(@"1—————————请求失败—————————");
        }
        [self hiddenLoading];
    }];
}

- (void)makeContentView:(PlanDetailsModel *)model {
    SolutionDetailsContentView *contentView = [[SolutionDetailsContentView alloc] initWithFrame:CGRectZero planDetails:model];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0.f);
        make.top.mas_equalTo(0.f);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(CONTENTHEIGHT_NOTOP);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

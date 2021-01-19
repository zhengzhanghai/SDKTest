//
//  KeyProjectDetailsViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/26.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "KeyProjectDetailsViewController.h"
#import "KeyProjectModel.h"
#import "KeyProjectDetailsContentView.h"
#import "KeyProjectBottomView.h"
#import "PreviewViewController.h"
#import "WatchOnlineViewController.h"
#import "KeyProjectCommentViewController.h"

#define BOTTOM_HEIGHT (IS_IPAD ? 65 : 50)

@interface KeyProjectDetailsViewController ()
@property (strong, nonatomic) KeyProjectModel *keyModel;

@end

@implementation KeyProjectDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的交钥匙项目";
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = [UIColor whiteColor];
    [self makePingJiaBtn];
    [self loadKeyProjectDEtails];
}

- (void)makePingJiaBtn {
    UIButton *pingJiaBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    pingJiaBtn.frame = CGRectMake(0, 0, 30, 20);
    pingJiaBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [pingJiaBtn setTitle:@"评价" forState:UIControlStateNormal];
    [pingJiaBtn setTitleColor:MainColor forState:UIControlStateNormal];
    [pingJiaBtn addTarget:self action:@selector(pingJia) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:pingJiaBtn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)pingJia {
    KeyProjectCommentViewController *vc = [[KeyProjectCommentViewController alloc] init];
    vc.keyProjectId = _keyProjectId;
    vc.hidesBottomBarWhenPushed = true;
    [self pushControllerHiddenTabbar:vc];
}

- (void)loadKeyProjectDEtails {
    NSString *url = API_POST_KEY_PROJECT_DETAILS;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
    dict[@"userId"] = [UserModel sharedModel].userId;
    dict[@"pakId"] = _keyProjectId;
    [[AINetworkEngine sharedClient] postWithApi:url parameters:dict CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result.isSucceed) {
            _keyModel = [KeyProjectModel modelWithDictionary:result.getDataObj];
            [self makeContentView];
            [self makeBottomView];
        } else {
            [self showError:self.view message:result.getMessage ? result.getMessage: @"请求失败"  afterHidden:1.3];
        }
    }];
}

- (void)makeContentView {
    KeyProjectDetailsContentView *contentView = [[KeyProjectDetailsContentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CONTENTHEIGHT_NOTOP-BOTTOM_HEIGHT) keyModel:_keyModel];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(TOPBARHEIGHT);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(CONTENTHEIGHT_NOTOP-BOTTOM_HEIGHT);
    }];
}

- (void)makeBottomView {
    KeyProjectBottomView *bottomView = [[KeyProjectBottomView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-BOTTOM_HEIGHT, SCREEN_WIDTH, BOTTOM_HEIGHT)];
    bottomView.clickItemBlock = ^(KeyProjectBottomViewType type) {
        switch (type) {
            case KeyProjectBottomViewTypeSimple:
                [self loadSimpleSolution];
                break;
            case KeyProjectBottomViewTypeCompletion:
                [self loadCompletedSolution];
                break;
            case KeyProjectBottomViewTypeBuy:
                [self orderKeyProject];
                break;
        }
    };
    [self.view addSubview:bottomView];
}

-(void)loadSimpleSolution{
    NSString *url = [NSString stringWithFormat:@"%@?solutionId=%@", API_GET_SIMPLE_SLOUTION_PDF, _solutionId];
    [self showLoadingToView:self.view];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            if (result.isSucceed) {
                NSArray *PDFs = [result getDataObj];
                NSDictionary *dict = [PDFs firstObject];
                if ([dict.allKeys containsObject:@"jpdfPath"]) {
                    PreviewViewController *vc = [[PreviewViewController alloc]init];
                    vc.url = dict[@"jpdfPath"];
                    vc.hidesBottomBarWhenPushed = true;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } else {
                [self showError:self.view message:result.getMessage afterHidden:2.f];
            }
        } else {
            
        }
        [self hiddenLoading];
    }];
}

-(void)loadCompletedSolution{
    NSString *url = API_POST_COMPLETE_SLOUTION_PDF;
    [self showLoadingToView:self.view];
    NSMutableDictionary *muDict = [NSMutableDictionary dictionaryWithCapacity:2];
    muDict[@"userId"] = [[UserModel sharedModel] userId];
    muDict[@"solutionId"] = _solutionId;
    [[AINetworkEngine sharedClient] postWithApi:url parameters:muDict CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            if (result.isSucceed) {
                NSArray *PDFs = [result getDataObj];
                NSDictionary *dict = [PDFs firstObject];
                if ([dict.allKeys containsObject:@"pdfPath"]) {
                    WatchOnlineViewController *vc = [[WatchOnlineViewController alloc] init];
                    vc.url = dict[@"pdfPath"];
                    vc.hidesBottomBarWhenPushed = true;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } else {
                [self showError:self.view message:result.getMessage afterHidden:2.f];
            }
        } else {
            
        }
        [self hiddenLoading];
    }];
}


- (void)orderKeyProject {
    NSString *url = API_POST_KEY_PROJECT_ORDER;
    NSMutableDictionary *muDict = [NSMutableDictionary dictionaryWithCapacity:2];
    muDict[@"userId"] = [[UserModel sharedModel] userId];
    muDict[@"pakId"] = _keyProjectId;
    [self showLoadingToView:self.view];
    [[AINetworkEngine sharedClient] postWithApi:url parameters:muDict CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            [self showError:self.view message:result.getMessage afterHidden:1.5];
        } else {
            [self showError:self.view message:@"失败" afterHidden:1.5];
        }
        [self hiddenLoading];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

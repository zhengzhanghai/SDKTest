//
//  KeyProjectSureFinishWorkViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/29.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "KeyProjectSureFinishWorkViewController.h"
#import "KeyProjectModel.h"
#import "KeyProjectDetailsContentView.h"
#import "EvaluateView.h"

#define BOTTOM_HEIGHT (IS_IPAD ? 55 : 40)

@interface KeyProjectSureFinishWorkViewController ()
@property (strong, nonatomic) KeyProjectModel *keyModel;
@property (strong, nonatomic) UIButton *bottomBtn;
@property (strong, nonatomic) KeyProjectDetailsContentView *contentView;
@end

@implementation KeyProjectSureFinishWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadKeyProjectDEtails];
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
    _contentView = [[KeyProjectDetailsContentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CONTENTHEIGHT_NOTOP-BOTTOM_HEIGHT) keyModel:_keyModel];
    [self.view addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(TOPBARHEIGHT);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(CONTENTHEIGHT_NOTOP-BOTTOM_HEIGHT);
    }];
}

- (void)makeBottomView {
    _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _bottomBtn.frame = CGRectMake(0, SCREEN_HEIGHT-BOTTOM_HEIGHT, SCREEN_WIDTH, BOTTOM_HEIGHT);
    _bottomBtn.backgroundColor = [UIColor redColor];
    [_bottomBtn setTitle:_sureString forState:UIControlStateNormal];
    [_bottomBtn addTarget:self action:@selector(clickSure) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bottomBtn];
}

- (void)clickSure {
    NSArray *titles = nil;
    if ([_sureString isEqualToString:@"确认完工"]) {
        titles = @[@"配合程度", @"付款及时", @"整体评价"];
    } else if ([_sureString isEqualToString:@"确认验收"]) {
        titles = @[@"专业水平", @"服务态度", @"整体评价"];
    }
    
    EvaluateView *evaluateView = [[EvaluateView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) titles:titles];
    UIViewController *rootController = [UIApplication sharedApplication].delegate.window.rootViewController;
    [rootController.view addSubview:evaluateView];
    __weak EvaluateView *weakEvaluateView = evaluateView;
    evaluateView.finishEvalueBlock = ^(NSArray *starArr, NSString *evaluateContent) {
        [self evaluate:starArr content:evaluateContent];
        [weakEvaluateView removeFromSuperview];
    };
}

- (void)evaluate:(NSArray *)starArr content:(NSString *)evaluateContent {
    if ([_sureString isEqualToString:@"确认完工"]) {
        [self sureFinishWork:starArr content:evaluateContent];
    } else if ([_sureString isEqualToString:@"确认验收"]) {
        [self sureYanShou:starArr content:evaluateContent];
    }
}

- (void)sureFinishWork:(NSArray *)starArr content:(NSString *)evaluateContent {
    [self showLoadingToView:self.view];
    NSString *url = API_POST_KEY_PROJECT_SURE_FINISH_WORK;
    NSDictionary *dict = @{@"pkgid": _keyProjectId,
                           @"userid": [UserModel sharedModel].userId,
                           @"playTogether": starArr[0],
                           @"promptPayment": starArr[1],
                           @"globalAssessment": starArr[2],
                           @"desc": evaluateContent};
    [[AINetworkEngine sharedClient]postWithApi:url parameters:dict CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            [self showSuccess:self.view message:result.getMessage afterHidden:1.5];
            if (result.isSucceed) {
                [self successRefresh];
            }
        } else {
            [self showError:self.view message:@"请求失败" afterHidden:1.5];
        }
        [self hiddenLoading];
    }];
}

- (void)sureYanShou:(NSArray *)starArr content:(NSString *)evaluateContent {
    [self showLoadingToView:self.view];
    NSString *url = API_POST_KEY_PROJECT_SURE_YANSHOU;
    NSDictionary *dict = @{@"pkgid": _keyProjectId,
                           @"userid": [UserModel sharedModel].userId,
                           @"expertiseLevel": starArr[0],
                           @"serverAttitude": starArr[1],
                           @"globalAssessment": starArr[2],
                           @"desc": evaluateContent};
    [[AINetworkEngine sharedClient] postWithApi:url parameters:dict CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            [self showSuccess:self.view message:result.getMessage afterHidden:1.5];
            if (result.isSucceed) {
                [self successRefresh];
            }
        } else {
            [self showError:self.view message:@"请求失败" afterHidden:1.5];
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
            if (result.isSucceed) {
                [self successRefresh];
            }
        } else {
            [self showError:self.view message:@"失败" afterHidden:1.5];
        }
        [self hiddenLoading];
    }];
}

- (void)successRefresh {
    [_bottomBtn removeFromSuperview];
    _bottomBtn = nil;
    [_contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(TOPBARHEIGHT);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(CONTENTHEIGHT_NOTOP);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

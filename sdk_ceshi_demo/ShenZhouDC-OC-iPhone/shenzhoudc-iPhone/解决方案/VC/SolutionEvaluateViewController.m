//
//  SolutionEvaluateViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/29.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "SolutionEvaluateViewController.h"
#import "EvaluateView.h"

@interface SolutionEvaluateViewController ()
@property (strong, nonatomic) EvaluateView *evaluateView;
@end

@implementation SolutionEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评价";
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeContentView];
}

- (void)makeContentView {
    _evaluateView = [[EvaluateView alloc] initSolutionWithFrame:CGRectMake(0, TOPBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-TOPBARHEIGHT) titles:@[@"创新性", @"实用性", @"适用性", @"准确性"]];
    [self.view addSubview:_evaluateView];
    __weak typeof(self) weakSelf = self;
    _evaluateView.finishEvalueBlock = ^(NSArray *starArr, NSString *evaluateContent) {
        [weakSelf evaluate:starArr content:evaluateContent];
    };
}

- (void)evaluate:(NSArray *)starArr content:(NSString *)evaluateContent {
    [self showLoadingToView:self.view];
    NSString *url = API_POST_SOLUTION_EVALUATE;
    NSDictionary *dict = @{@"solutionid": _solutionId,
                           @"userid": [UserModel sharedModel].userId,
                           @"novelty": starArr[0],
                           @"practicability": starArr[1],
                           @"usability": starArr[2],
                           @"veractiy": starArr[3],
                           @"content": evaluateContent};
    [[AINetworkEngine sharedClient] postWithApi:url parameters:dict CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            [self showSuccess:self.view message:result.getMessage afterHidden:1.5];
            if (result.isSucceed) {
                [self showSuccess:self.view message:result.getMessage afterHidden:1.5];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:true];
                });
            } else {
                [self showError:self.view message:result.getMessage afterHidden:1.5];
            }
        } else {
            [self showError:self.view message:@"请求失败" afterHidden:1.5];
        }
        [self hiddenLoading];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

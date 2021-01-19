//
//  ShensuViewController.m
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2017/5/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ShensuViewController.h"

@interface ShensuViewController ()<UITextViewDelegate>

@property (nonatomic ,strong) UITextView *commentTextView;
@property (nonatomic, strong) UILabel *placeHoldLabel;

@end

@implementation ShensuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=  [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"投诉";
    self.view.backgroundColor = UIColorFromRGB(0xEAEAEA);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self makeUI];
    
}
- (void)makeUI {
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVBARHEIGHT+STATUSBARHEIGHT, SCREEN_WIDTH, LandscapeNumber(180))];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    self.commentTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LandscapeNumber(180))];
    //    self.commentTextView.layer.borderColor = [UIColor redColor].CGColor;
    //    self.commentTextView.layer.borderWidth = 1;
    self.commentTextView.textColor = UIColorFromRGB(0x0F0F0F);
    self.commentTextView.font = [UIFont systemFontOfSize:16];
    self.commentTextView.delegate = self;
    [topView addSubview:self.commentTextView];
    
    self.placeHoldLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, SCREEN_WIDTH-40, 16)];
    self.placeHoldLabel.text = @"请陈述投诉内容…";
    self.placeHoldLabel.font = [UIFont systemFontOfSize:16];
    self.placeHoldLabel.textColor = UIColorFromRGB(0x666666);
    [topView addSubview:self.placeHoldLabel];
    
 
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-51, SCREEN_WIDTH, 51)];
    btn.backgroundColor = UIColorFromRGB(0xD71629);
    [btn addTarget:self action:@selector(clickPublick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"确定投诉" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:btn];
    
    
}
//点击 发布
- (void)clickPublick {
    if ([self.commentTextView.text isEqualToString:@""]) {
        [self showError:self.view message:@"投诉内容不能为空" afterHidden:3];
        return;
    }
    
    NSString *api = [NSString stringWithFormat:@"%@v1/details/PublishDeclarant/",DOMAIN_NAME];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"declarantid"] = [UserModel sharedModel].userId;
    params[@"ordersn"] = self.orderSn;
    params[@"declarantContent"] = self.commentTextView.text;
    
    [[AINetworkEngine sharedClient] postWithApi:api parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
        NSLog(@"%@",result);
        if (result != nil) {
            if ([result isSucceed]) {
                NSLog(@"投诉成功");
                [self showSuccess:self.view message:result.getMessage afterHidden:4];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } else {
                [self showSuccess:self.view message:result.getMessage afterHidden:2];
            }
        } else {
            [self showSuccess:self.view message:@"请求失败" afterHidden:2];
        }
        
    }];
    
    
}
- (void)textViewDidChange:(UITextView *)textView {
    if (![textView.text isEqualToString:@""]) {
        self.placeHoldLabel.hidden = YES;
    }else{
        self.placeHoldLabel.hidden = NO;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

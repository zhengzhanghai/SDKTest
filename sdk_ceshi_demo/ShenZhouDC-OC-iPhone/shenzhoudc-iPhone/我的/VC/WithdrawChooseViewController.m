//
//  WithdrawChooseViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/7/6.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "WithdrawChooseViewController.h"
#import "BindingAlipayViewController.h"

@interface WithdrawChooseViewController ()

@end

@implementation WithdrawChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择提现方式";
    self.view.backgroundColor = UIColorFromRGB(0xfafafa);
    ;
    [self initPaymentView];
}

- (void)initPaymentView {
    
    NSArray *titles = @[@"支付宝", @"微信支付", @"押金提现"];
    NSArray *images = @[@"pay_ali_icon", @"pay_wechat_icon", @"pay_ya_icon"];
    NSArray *arr = @[@"tixian_blue", @"tixian_green", @"tixian_orange"];
    
    CGFloat btnWidth =  SCREEN_WIDTH-30;
    CGFloat btnHeight = 50;
    
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:btn];
        btn.layer.cornerRadius = 2;
        btn.clipsToBounds = true;
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(NAVBARHEIGHT+STATUSBARHEIGHT+15+i*(btnHeight+15));
            make.width.mas_equalTo(btnWidth);
            make.height.mas_equalTo(btnHeight);
        }];
        
        UIImageView *leftIcon = [[UIImageView alloc] init];
        leftIcon.image = [UIImage imageNamed:arr[i]];
        [btn addSubview:leftIcon];
        [leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(2);
        }];
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:images[i]]];
        [btn addSubview:icon];
        icon.userInteractionEnabled = false;
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(34);
            make.height.mas_equalTo(34);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        [btn addSubview:label];
        label.userInteractionEnabled = false;
        label.text = titles[i];
        label.textColor = UIColorFromRGB(0x1e1e1e);
        label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        label.userInteractionEnabled = NO;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(icon.mas_right).offset(12);
            make.centerY.mas_equalTo(0);
        }];
        
        UIImageView *enterIcon = [[UIImageView alloc] init];
        enterIcon.image = [UIImage imageNamed:@"pay_enter"];
        [btn addSubview:enterIcon];
        [enterIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-13);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(14);
            make.height.mas_equalTo(14);
        }];
    }
}

- (void)clickBtn:(UIButton *)btn {
    switch (btn.tag) {
        case 0:
            [self applyWithdrawToAlipay];
            break;
        case 1:
            [self applyWithdrawToWechat];
            break;
        case 2:
            [self applyWithdrawToCompany];
            break;
            
    }
}

- (void)applyWithdrawToWechat {
    [self showLoadingToView:self.view];
    NSString *url = API_POST_APPLY_WITHDRAW_WECHAT;
    NSDictionary *dict = @{@"userId": [UserModel sharedModel].userId,
                           @"price": [NSString stringWithFormat:@"%.2f", _withdrawMoney.floatValue]};
    [[AINetworkEngine sharedClient] postWithApi:url parameters:dict CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            if (result.getCode == 1001) {
                [self alertVCWIthMessage:@"未绑定微信，前去绑定？" type:2];
            } else {
                [self showSuccess:self.view message:result.getMessage afterHidden:2];
            }
        } else {
            [self showError:self.view message:@"请求失败" afterHidden:2];
        }
        [self hiddenLoading];
    }];
}

- (void)applyWithdrawToAlipay {
    [self showLoadingToView:self.view];
    NSString *url = API_POST_APPLY_WITHDRAW_APLPAY;
    NSDictionary *dict = @{@"userId": [UserModel sharedModel].userId,
                           @"price": [NSString stringWithFormat:@"%.2f", _withdrawMoney.floatValue]};
    [[AINetworkEngine sharedClient] postWithApi:url parameters:dict CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            if (result.getCode == 1001) {
                [self alertVCWIthMessage:@"未绑定支付宝，前去绑定？" type:1];
            } else if (result.getCode == 1000) {
                [self showError:self.view message:result.getMessage afterHidden:2];
            } else if (result.getCode == 1002) {
                [self showError:self.view message:result.getMessage afterHidden:2];
            } else {
                [self showError:self.view message:result.getMessage afterHidden:2];
            }
        } else {
            [self showError:self.view message:@"请求失败" afterHidden:1.5];
        }
        [self hiddenLoading];
    }];
}

- (void)applyWithdrawToCompany {
    [self showLoadingToView:self.view];
    NSString *url = API_POST_APPLY_WITHDRAW_COMPANY;
    NSDictionary *dict = @{@"userId": [UserModel sharedModel].userId,
                           @"price": [NSString stringWithFormat:@"%.2f", _withdrawMoney.floatValue]};
    [[AINetworkEngine sharedClient] postWithApi:url parameters:dict CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            if (result.getCode == 1001) {
                [self alertVCWIthMessage:@"未绑定支付宝，前去绑定？" type:1];
            } else {
                [self showError:self.view message:result.getMessage afterHidden:2];
            }
        } else {
            [self showError:self.view message:@"请求失败" afterHidden:1.5];
        }
        [self hiddenLoading];
    }];
}

- (void)bindingWechat:(NSString *)wechatOpenId {
    [self showLoadingToView:self.view];
    NSString *url = API_POST_BINDING_WECHAT;
    NSDictionary *dict = @{@"userId": [UserModel sharedModel].userId,
                           @"openId": wechatOpenId};
    [[AINetworkEngine sharedClient] postWithApi:url parameters:dict CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            [self showError:self.view message:result.getMessage afterHidden:2];
        } else {
            [self showError:self.view message:@"请求失败" afterHidden:1.5];
        }
        [self hiddenLoading];
    }];
}

- (void)bindingAlipay:(NSString *)alipayAccount {
    [self showLoadingToView:self.view];
    NSString *url = API_POST_BINDING_ALIPAY;
    NSDictionary *dict = @{@"userId": [UserModel sharedModel].userId,
                           @"unionId": alipayAccount};
    [[AINetworkEngine sharedClient] postWithApi:url parameters:dict CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            [self showError:self.view message:result.getMessage afterHidden:2];
        } else {
            [self showError:self.view message:@"请求失败" afterHidden:1.5];
        }
        [self hiddenLoading];
    }];
}

- (void)alertVCWIthMessage:(NSString *)message type:(NSInteger)type {
    NoAutorotateAlertController *alertVC = [NoAutorotateAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self evokeAppWithType:type];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertVC addAction:sureAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:true completion:nil];
}

- (void)evokeAppWithType:(NSInteger)type {
    // 1.支付宝  2.微信
    if (type == 1) {
        BindingAlipayViewController *vc = [[BindingAlipayViewController alloc] init];
        vc.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:vc animated:true];
    } else if (type == 2) {
        
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

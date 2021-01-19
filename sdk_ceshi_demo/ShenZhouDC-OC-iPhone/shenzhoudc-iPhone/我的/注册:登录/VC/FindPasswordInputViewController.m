//
//  FindPasswordInputViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/7/10.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "FindPasswordInputViewController.h"

@interface FindPasswordInputViewController ()
@property (strong, nonatomic) UITextField *passwordTFOne;
@property (strong, nonatomic) UITextField *passwordTFTwo;
@end

@implementation FindPasswordInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"输入新密码";
    self.view.backgroundColor = UIColorFromRGB(0xeaeaea);
    [self makeUI];
}

- (void)makeUI {
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top).with.offset(NAVBARHEIGHT+STATUSBARHEIGHT+(IS_IPAD ? 50 : 33));
        make.right.mas_equalTo(0);
    }];
    
    
    self.passwordTFOne = [[UITextField alloc] init];
    self.passwordTFOne.placeholder = @"输入新密码";
    self.passwordTFOne.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTFOne.textColor = UIColorFromRGB(0x666666);
    self.passwordTFOne.secureTextEntry = true;
    self.passwordTFOne.font = [UIFont systemFontOfSize:14];
    [backView addSubview:self.passwordTFOne];
    [self.passwordTFOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView.mas_left).offset(12);
        make.top.mas_equalTo(backView.mas_top);
        make.width.mas_equalTo(SCREEN_WIDTH-24);
        make.height.mas_equalTo(IS_IPAD ? 55 : 44);
    }];
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xEAEAEA);
    [backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView.mas_left);
        make.top.mas_equalTo(_passwordTFOne.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
    }];
    
    self.passwordTFTwo = [[UITextField alloc]init];
    self.passwordTFTwo.placeholder = @"确认密码";
    self.passwordTFTwo.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTFTwo.textColor = UIColorFromRGB(0x555555);
    self.passwordTFTwo.font = [UIFont systemFontOfSize:14];
    self.passwordTFTwo.secureTextEntry = true;
    [backView addSubview:self.passwordTFTwo];
    [self.passwordTFTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.passwordTFOne.mas_left);
        make.top.mas_equalTo(line.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH-24);
        make.height.mas_equalTo(IS_IPAD ? 55 : 44);
        make.bottom.mas_equalTo(0);
    }];
    
    UIButton *logBtn = [[UIButton alloc]init];
    logBtn.layer.masksToBounds = YES;
    logBtn.layer.cornerRadius = 6;
    logBtn.backgroundColor = MainColor;
    [logBtn setTitle:@"确定" forState:UIControlStateNormal];
    [logBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [logBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logBtn];
    [logBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(12);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-24,IS_IPAD ? 55 : 44));
        make.top.mas_equalTo(backView.mas_bottom).offset(IS_IPAD ? 50 : 33);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.textColor = UIColorFromRGB(0x5C5C5C);
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"如何设置可靠的密码？";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(logBtn.mas_left);
        make.top.mas_equalTo(logBtn.mas_bottom).with.offset(LandscapeNumber(36));
    }];
    
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.textColor = UIColorFromRGB(0x5C5C5C);
    detailLabel.font = [UIFont systemFontOfSize:12];
    detailLabel.text = @"1.密码长度为8位以上\n2.密码中包含数字、字母和特殊字符\n3.加入1-2个大写字母\n4.不使用一些连续的重复的字母和数字\n";
    detailLabel.numberOfLines = 0;
    [self.view addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_left);
        make.top.mas_equalTo(label.mas_bottom).with.offset(10);
    }];
}

- (void)clickConfirmBtn {
    if (_passwordTFOne.text.length < 8) {
        [self showError:self.view message:@"密码8位以上" afterHidden:2];
        return;
    }
    if (_passwordTFTwo.text.length < 8) {
        [self showError:self.view message:@"密码8位以上" afterHidden:2];
        return;
    }
    if (![_passwordTFOne.text isEqualToString:_passwordTFTwo.text]) {
        [self showError:self.view message:@"密码不一致" afterHidden:2];
        return;
    }
    [self showLoadingToView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = _mobile;
    params[@"authCode"] = _authCode;
    params[@"password"] = _passwordTFOne.text;
    params[@"repassword"] = _passwordTFTwo.text;

    [[AINetworkEngine sharedClient] postWithApi:API_POST_PASSWORD_RESET parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
        NSLog(@"%@",result);
        if (result != nil) {
            NSLog(@"succeed:msg:%@", result.getMessage);
            if(result.isSucceed){
                //密码修改成功
                [self showSuccess:AppDelegateWindowRootController.view message:@"重设密码成功" afterHidden:2];
                NSArray *viewControllers = self.navigationController.viewControllers;
                NSInteger index = [viewControllers indexOfObject:self];
                if (index >= 2) {
                    [self.navigationController popToViewController:viewControllers[index-2] animated:true];
                }
            } else {
                [self showError:self.view message:result.getMessage afterHidden:2];
            }
        }else{
            [self showError:self.view message:@"请求失败" afterHidden:2];
        }
        [self hiddenLoading];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

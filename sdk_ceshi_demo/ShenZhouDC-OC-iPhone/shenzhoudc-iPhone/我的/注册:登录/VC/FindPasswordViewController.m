//
//  FindPasswordViewController.m
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 16/12/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "SwiftCountdownButton.h"
#import "NSString+CustomString.h"
#import "FindPasswordInputViewController.h"

@interface FindPasswordViewController ()
@property (nonatomic, strong) UITextField *phoneNumTextField;
@property (nonatomic, strong) UITextField *authCodeTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *AnotherPasswordTextField;
@property (nonatomic, strong) NSString *authCode;//保存服务器返回的验证码

@end

@implementation FindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    self.view.backgroundColor = UIColorFromRGB(0xEAEAEA);
    [self makeUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makeUI {
    
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_top).offset(NAVBARHEIGHT+STATUSBARHEIGHT+(IS_IPAD ? 50 : 33));
    }];
    
    self.phoneNumTextField = [[UITextField alloc]init];
    self.phoneNumTextField.placeholder = @"请输入绑定的手机号码";
    self.phoneNumTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneNumTextField.textColor = UIColorFromRGB(0x666666);
    self.phoneNumTextField.font = [UIFont systemFontOfSize:14];
    self.phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    [backView addSubview:self.phoneNumTextField];
    [self.phoneNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView.mas_left).offset(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(backView.mas_top);
        make.height.mas_equalTo(IS_IPAD ? 55 : 44);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xEAEAEA);
    [backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(backView);
        make.top.mas_equalTo(_phoneNumTextField.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    NSString *str = @"获取验证码";
    CGFloat btnW = [str getWidthWithContent:str height:20 font:13];
    
    SwiftCountdownButton *authCodeBtn = [[SwiftCountdownButton alloc]init];
    authCodeBtn.layer.masksToBounds = YES;
    authCodeBtn.layer.cornerRadius = 4;
    authCodeBtn.backgroundColor = [UIColor clearColor];
    authCodeBtn.layer.borderWidth = 1;
    authCodeBtn.layer.borderColor = MainColor.CGColor;
    [authCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [authCodeBtn setTitleColor:MainColor forState:UIControlStateNormal];
    authCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [authCodeBtn addTarget:self action:@selector(getAuthCode:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:authCodeBtn];
    [authCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(backView.mas_right).with.offset(-12);
        make.top.mas_equalTo(line.mas_bottom).with.offset(7);
        make.size.mas_equalTo(CGSizeMake(btnW + 20, IS_IPAD ? 40 : 32));
    }];
    
    UIView *vertcalLine = [[UIView alloc]init];
    vertcalLine.backgroundColor = UIColorFromRGB(0xDDDDDD);
    [backView addSubview:vertcalLine];
    [vertcalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(authCodeBtn);
        make.width.mas_equalTo(1);
        make.right.mas_equalTo(authCodeBtn.mas_left).offset(-6);
    }];
    
    
    self.authCodeTextField = [[UITextField alloc]init];
    self.authCodeTextField.placeholder = @"填写验证码";
    self.authCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.authCodeTextField.textColor = UIColorFromRGB(0x555555);
    self.authCodeTextField.font = [UIFont systemFontOfSize:14];
    self.authCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [backView addSubview:self.authCodeTextField];
    [self.authCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneNumTextField.mas_left);
        make.right.mas_equalTo(vertcalLine.mas_left).offset(-10);
        make.top.mas_equalTo(line.mas_bottom);
        make.height.mas_equalTo(IS_IPAD ? 55 : 44);
        make.bottom.mas_equalTo(0);
    }];
        
    UIButton *logBtn = [[UIButton alloc]init];
    logBtn.layer.masksToBounds = YES;
    logBtn.layer.cornerRadius = 6;
    logBtn.backgroundColor = MainColor;
    [logBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [logBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [logBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logBtn];
    [logBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(12);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-24,IS_IPAD ? 55 : 44));
        make.top.mas_equalTo(backView.mas_bottom).offset(IS_IPAD ? 50 : 33);
    }];
}
-(void)getAuthCode:(SwiftCountdownButton *)sender {
    if (![GlobleFunction isMobileNumber:self.phoneNumTextField.text]) {
        //手机号有误
        return;
    }
    sender.maxSecond = 60;
    sender.countdown = YES;
    
    [self getAuthCodeRequest];
    
}
//点击 确认按钮
-(void)clickConfirmBtn {
    
    [self.phoneNumTextField resignFirstResponder];
    [self.authCodeTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.AnotherPasswordTextField resignFirstResponder];
   

    if (![GlobleFunction isMobileNumber:self.phoneNumTextField.text]) {
        //手机号有误
        [self showError:self.view message:@"请检查手机号" afterHidden:2];
        return;
    }
//    if ([self.passwordTextField.text isEqualToString:@""]){
//        //密码不能为空
//        [self showError:self.view message:@"密码不能为空" afterHidden:2];
//        return;
//    }
//    if ([self.AnotherPasswordTextField.text isEqualToString:@""]){
//        //新密码不能为空
//        [self showError:self.view message:@"新密码不能为空" afterHidden:2];
//        return;
//    }
    if ([self.authCodeTextField.text isEqualToString:@""]){
        //验证码有误
        [self showError:self.view message:@"请输入验证码" afterHidden:2];
        return;
    }
//    [self resetUserPasswordRequest];
    [self yanZhengAuthCode];
    
}

- (void)yanZhengAuthCode {
    [self showLoadingToView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = self.phoneNumTextField.text;
    params[@"authCode"] = self.authCodeTextField.text;
    NSLog(@"%@",params);
    [[AINetworkEngine sharedClient] postWithApi:API_POST_PASSWORD_AUTH parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
        NSLog(@"%@",result);
        if (result != nil) {
            NSLog(@"succeed:msg:%@", result.getMessage);
            if(result.isSucceed){
                //密码修改成功
                FindPasswordInputViewController *vc = [[FindPasswordInputViewController alloc] init];
                vc.mobile = self.phoneNumTextField.text;
                vc.authCode = self.authCodeTextField.text;
                vc.hidesBottomBarWhenPushed = true;
                [self.navigationController pushViewController:vc animated:true];
            } else {
                [self showError:self.view message:result.getMessage afterHidden:2];
            }
        }else{
            [self showError:self.view message:@"请求失败" afterHidden:2];
        }
        [self hiddenLoading];
    }];
}

//点击 获取验证码
-(void)getAuthCodeRequest {
    
    NSString *url = [NSString stringWithFormat:@"v1/user/code?m=%@",self.phoneNumTextField.text];
    
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        NSLog(@"返回结果 %@",result);
        if (result != nil) {
            NSLog(@"succeed:msg:%@", result.getMessage);
            if(result.isSucceed){
                NSDictionary *dic = result.getDataObj;
                NSLog(@"%@",dic);
                //验证码
                self.authCode = [dic objectForKey:@"authCode"];
                //验证码回填
                self.authCodeTextField.text = self.authCode;
            }
        }else{
            NSLog(@"错误 %@",error);
        }
        
    }]; 
}

//重置 密码
-(void)resetUserPasswordRequest {
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = self.phoneNumTextField.text;
    params[@"authCode"] = self.authCodeTextField.text;
    params[@"password"]= self.passwordTextField.text;
    NSLog(@"%@",params);
    [[AINetworkEngine sharedClient] postWithApi:API_POST_RESET_PASSWORD parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
        NSLog(@"%@",result);
        if (result != nil) {
            NSLog(@"succeed:msg:%@", result.getMessage);
            if(result.isSucceed){
                //密码修改成功
                [self showSuccess:self.view message:@"密码修改成功" afterHidden:3];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            NSLog(@"%@",error);
        }
        
    }];
}

@end

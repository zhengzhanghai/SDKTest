//
//  LoginViewController.m
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/23.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "FindPasswordViewController.h"
#import "AFNetworking.h"



@interface LoginViewController ()

@property (nonatomic ,strong) UITextField *accountNameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *logBtn;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"登录";
    self.view.backgroundColor = UIColorFromRGB(0xEAEAEA);
    [self makeUI];
  
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
}

-(void)makeUI {
    
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_top).with.offset(NAVBARHEIGHT+STATUSBARHEIGHT+(IS_IPAD ? 50 : 33));
    }];
    

    self.accountNameTextField = [[UITextField alloc]init];
    self.accountNameTextField.placeholder = @"手机号/邮箱/用户名";
    self.accountNameTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.accountNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.accountNameTextField becomeFirstResponder];
    self.accountNameTextField.textColor = UIColorFromRGB(0x666666);
    self.accountNameTextField.font = [UIFont systemFontOfSize:16];
    [backView addSubview:self.accountNameTextField];
    [self.accountNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView.mas_left).offset(10);
        make.top.mas_equalTo(backView.mas_top);
        make.width.mas_equalTo(SCREEN_WIDTH-20);
        make.height.mas_equalTo(IS_IPAD ? 55 : 44);
    }];
    
    
    UIImageView *leftVN = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"登录-用户ico"]];
    leftVN.frame = CGRectMake(0, 0, 55, 20);
    leftVN.contentMode = UIViewContentModeCenter;
    self.accountNameTextField.leftViewMode = UITextFieldViewModeAlways;
    UIView *accountLeftV = [[UIView alloc] init];
    accountLeftV.frame = CGRectMake(0, 0, 55, 20);
    [accountLeftV addSubview:leftVN];
    self.accountNameTextField.leftView = accountLeftV;
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xEAEAEA);
    [backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView.mas_left);
        make.top.mas_equalTo(_accountNameTextField.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
    }];
    
    self.passwordTextField = [[UITextField alloc]init];
    self.passwordTextField.placeholder = @"密码";
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.textColor = UIColorFromRGB(0x666666);
    self.passwordTextField.font = [UIFont systemFontOfSize:16];
    [backView addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.accountNameTextField.mas_left);
        make.top.mas_equalTo(line.mas_bottom);
        make.width.mas_equalTo(self.accountNameTextField.mas_width);
        make.height.mas_equalTo(self.accountNameTextField.mas_height);
        make.bottom.mas_equalTo(0);
    }];
    [self.passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    UIImageView  *leftVP = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"登录-密码ico"]];
    leftVP.frame = CGRectMake(0, 0, 55, 20);
    leftVP.contentMode = UIViewContentModeCenter;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *passwordLeftV = [[UIView alloc] init];
    passwordLeftV.frame = CGRectMake(0, 0, 55, 20);
    [passwordLeftV addSubview:leftVP];
    self.passwordTextField.leftView = passwordLeftV;
    
    
    self.logBtn = [[UIButton alloc]init];
    self.logBtn.layer.masksToBounds = YES;
    self.logBtn.layer.cornerRadius = 4;
    self.logBtn.backgroundColor = UIColorFromRGB(0xffaaaa);
    [self.logBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.logBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.logBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.logBtn addTarget:self action:@selector(clickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.logBtn];
    [self.logBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).with.offset(14);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-14);
        make.height.mas_equalTo(IS_IPAD ? 55 : 44);
        make.top.mas_equalTo(backView.mas_bottom).with.offset(IS_IPAD ? 50 : 33);
    }];
    
   
    
    UIButton *forgetBtn = [[UIButton alloc]init];
    forgetBtn.backgroundColor = [UIColor clearColor];
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:MainColor forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [forgetBtn addTarget:self action:@selector(clickForgetBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.logBtn.mas_left);
        make.top.mas_equalTo(self.logBtn.mas_bottom).with.offset(15);
        make.height.mas_equalTo(20);
    }];
    

    UIButton *registerBtn = [[UIButton alloc]init];
    registerBtn.backgroundColor = [UIColor clearColor];
    [registerBtn setTitle:@"快速注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:MainColor forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [registerBtn addTarget:self action:@selector(clickRegisterBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.logBtn.mas_right);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(forgetBtn.mas_top);
    }];
    
}

-(void)textFieldDidChange :(UITextField *)theTextField {
    
    if (theTextField.text.length != 0) {
        self.logBtn.backgroundColor = MainColor;
        self.logBtn.userInteractionEnabled = YES;
        
    }else if (theTextField.text.length == 0){
        self.logBtn.backgroundColor = UIColorFromRGB(0xffaaaa);
        self.logBtn.userInteractionEnabled = NO;
    }
    
}

//点击  登录
-(void)clickLoginBtn:(UIButton *)sender {
    if ([self.accountNameTextField.text isEqualToString:@""]) {
        //用户名不能为空
        return;
    }else if ([self.passwordTextField.text isEqualToString:@""]) {
        //密码不能为空
        return;
    }
        [self.accountNameTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        [self sendLoginRequest];
   

}

//点击 注册
-(void)clickRegisterBtn {

    RegisterViewController *vc = [[RegisterViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:true];
    
    
}
//点击 忘记密码
-(void)clickForgetBtn {
    
    FindPasswordViewController *vc = [[FindPasswordViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//点击 登录
-(void)sendLoginRequest {
    [self showLoadingToView:self.view];
    AINetworkEngine *manager = [AINetworkEngine sharedClient];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"accountName"] = self.accountNameTextField.text;
    params[@"password"] = self.passwordTextField.text;
    
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"source"];//设置请求头
    NSLog(@"%@",params);
    NSString *api = [NSString stringWithFormat:@"%@v1/user/login",DOMAIN_NAME];//,API_POST_LOGIN
    [manager postWithApi:api parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result != nil) {
            if(result.isSucceed){
                NSLog(@"登录接口：登录成功");
                //将用户登录信息保存到本地 token 、userId
                NSMutableDictionary *resultDic = [[NSMutableDictionary alloc]init];
                NSDictionary *dic = result.getDataObj;
                NSString *token = [dic objectForKey:@"token"];
                NSDictionary *userDic = [GlobleFunction parseToken:token];
                [resultDic addEntriesFromDictionary:dic];
                [resultDic addEntriesFromDictionary:userDic];
                UserModel *model = [UserModel modelWithDictionary:resultDic];
                [model writeToLocal];
               //获取用户基本信息
                [self loadUserBaseInfoRequest];
            }else{
                NSLog(@"登录接口能通：登录失败");
                [self hiddenLoading];
                [self showError:self.view message:result.getMessage afterHidden:2];
            }
        }else{
            NSLog(@"登录接口不通");
            [self hiddenLoading];
            [self showError:self.view message:@"登录失败" afterHidden:3];
        }
    }];
}

//获取用户资料
-(void)loadUserBaseInfoRequest {
    
    NSString *url = [NSString stringWithFormat:@"%@v1/user/getUsers?id=%@",DOMAIN_NAME,[UserModel sharedModel].userId];
    NSLog(@"%@",url);
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        [self hiddenLoading];
        if (result != nil) {
            if(result.isSucceed){
                NSDictionary *dic = result.getDataObj;
                dic = [NSDictionary changeType:dic];
                UserBaseInfoModel *model = [UserBaseInfoModel modelWithDictionary:dic];
                [model writeToLocal];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMe" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil];
                [self showSuccess:App_Delegate.window message:@"登录成功" afterHidden:2];
                [self.navigationController popViewControllerAnimated:YES];
//                [self showSuccess:self.view message:@"登录成功" afterHidden:2];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self.navigationController popViewControllerAnimated:YES];
//                });
            } else {
                [self showError:self.view message:result.getMessage afterHidden:3];
            }
        }else{
            [self showError:self.view message:@"登录失败" afterHidden:3];
        }
    }];
}


//修改 密码
-(void)modifyUserPasswordRequest {
    
    NSString *url = [NSString stringWithFormat:@"%@user/password/modify",DOMAIN_NAME];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"accountName"] = @"";
    params[@"￼￼oldPassword"] = @1;
    params[@"newPassword"] = @"";
    
    [[AINetworkEngine sharedClient] postWithApi:url parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
        
        if (result != nil) {
            NSLog(@"succeed:msg:%@", result.getMessage);
            if(result.isSucceed){
                //密码重置成功
                
            }
        }
        
    }];
    
}



@end

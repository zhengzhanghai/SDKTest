//
//  RegisterViewController.m
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/23.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "RegisterViewController.h"
#import "SwiftCountdownButton.h"
#import "NSString+CustomString.h"
#import "ProtocolViewController.h"
#import "ProtocolModel.h"
#import "ProtocolPDFViewController.h"

@interface RegisterViewController ()

@property (nonatomic, strong) UITextField *phoneNumTextField;
@property (nonatomic, strong) UITextField *authCodeTextField;//验证码
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, assign) BOOL isRead;//是否已阅读协议
@property (nonatomic, strong) NSString *authCode;//保存服务器返回的验证码
@property (nonatomic, strong) UIButton *logBtn;
@property (strong, nonatomic) NSArray *protocolArray;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机注册";
    self.view.backgroundColor = UIColorFromRGB(0xEAEAEA);
    [self loadRegisterProtocol];
}

- (void)loadRegisterProtocol {
    NSString *url = API_GET_USER_PROTOCOL;
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result.isSucceed) {
            NSArray *list = result.getDataObj;
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:list.count];
            for (NSUInteger i = 0; i < list.count; i++) {
                [arr addObject:[ProtocolModel modelWithDictionary:list[i]]];
            }
            _protocolArray = arr;
            [self makeUI];
        } else {
            [self showError:self.view message:@"获取协议失败，请重试" afterHidden:1.5];
        }
    }];
}

-(void)makeUI {
    
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.view.mas_top).offset(NAVBARHEIGHT+STATUSBARHEIGHT+(IS_IPAD?50:33));
    }];
    
    self.phoneNumTextField = [[UITextField alloc]init];
    self.phoneNumTextField.placeholder = @"请输入手机号";
    self.phoneNumTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneNumTextField.textColor = UIColorFromRGB(0x666666);
    self.phoneNumTextField.font = [UIFont systemFontOfSize:14];
    self.phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    [backView addSubview:self.phoneNumTextField];
    [self.phoneNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView.mas_left).offset(10);
        make.top.mas_equalTo(backView.mas_top);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(IS_IPAD ? 55 : 44);
    }];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    nameLabel.textColor = UIColorFromRGB(0x555555);
    nameLabel.text = @"手机号：";
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.contentMode = UIViewContentModeCenter;
    self.phoneNumTextField.leftViewMode = UITextFieldViewModeAlways;
    self.phoneNumTextField.leftView = nameLabel;
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xEAEAEA);
    [backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView.mas_left);
        make.top.mas_equalTo(_phoneNumTextField.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
    }];
    
    NSString *str = @"获取验证码";
    CGFloat btnW = [str getWidthWithContent:str height:20 font:13];
    
    SwiftCountdownButton *authCodeBtn = [[SwiftCountdownButton alloc]init];
    authCodeBtn.layer.masksToBounds = YES;
    authCodeBtn.layer.cornerRadius = 4;
    authCodeBtn.backgroundColor = MainColor;
    [authCodeBtn setTitle:str forState:UIControlStateNormal];
    [authCodeBtn setTitle:@"" forState:UIControlStateDisabled];
    [authCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [authCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    authCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [authCodeBtn addTarget:self action:@selector(getAuthCode:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:authCodeBtn];
    [authCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(backView.mas_right).offset(-5);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(btnW + 20, IS_IPAD ? 40 :32));
    }];
    
    self.authCodeTextField = [[UITextField alloc]init];
    self.authCodeTextField.placeholder = @"6位验证码";
    self.authCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.authCodeTextField.textColor = UIColorFromRGB(0x555555);
    self.authCodeTextField.font = [UIFont systemFontOfSize:14];
    self.authCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [backView addSubview:self.authCodeTextField];
    [self.authCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneNumTextField.mas_left);
        make.top.mas_equalTo(line.mas_bottom);
        make.right.mas_equalTo(authCodeBtn.mas_left).offset(-10);
        make.height.mas_equalTo(IS_IPAD ? 55 : 40);
    }];
    
    UILabel *authLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    authLabel.textColor = UIColorFromRGB(0x555555);
    authLabel.text = @"验证码：";
    authLabel.font = [UIFont systemFontOfSize:14];
    authLabel.contentMode = UIViewContentModeCenter;
    self.authCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    self.authCodeTextField.leftView = authLabel;
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = UIColorFromRGB(0xEAEAEA);
    [backView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line.mas_left);
        make.top.mas_equalTo(_authCodeTextField.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
    }];
    
    self.passwordTextField = [[UITextField alloc]init];
    self.passwordTextField.placeholder = @"6~11位";
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.textColor = UIColorFromRGB(0x555555);
    self.passwordTextField.font = [UIFont systemFontOfSize:14];
    [backView addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneNumTextField.mas_left);
        make.top.mas_equalTo(line1.mas_bottom);
        make.width.mas_equalTo(self.phoneNumTextField.mas_width);
        make.height.mas_equalTo(self.phoneNumTextField.mas_height);
        make.bottom.mas_equalTo(0);
    }];
    
    
    UILabel *passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    passwordLabel.textColor = UIColorFromRGB(0x555555);
    passwordLabel.textAlignment = NSTextAlignmentJustified;
    passwordLabel.text = @"密码：";
    passwordLabel.font = [UIFont systemFontOfSize:14];
    passwordLabel.contentMode = UIViewContentModeCenter;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.leftView = passwordLabel;
    [self.passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIButton *readBtn = [[UIButton alloc]init];
    readBtn.backgroundColor = [UIColor whiteColor];
    readBtn.layer.masksToBounds = YES;
    readBtn.layer.cornerRadius = 6;
    readBtn.selected = YES;
    self.isRead = YES;
    [readBtn setImage:[UIImage imageNamed:@"register_yes"] forState:UIControlStateSelected];
    [readBtn addTarget:self action:@selector(clickReadBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:readBtn];
    [readBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView.mas_left);
        make.top.mas_equalTo(backView.mas_bottom).offset(IS_IPAD ? 30 : 20);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    UILabel *readLabel = [[UILabel alloc]init];
    readLabel.textColor = [UIColor blackColor];
    readLabel.textAlignment = NSTextAlignmentJustified;
    readLabel.text = @"我已阅读并接受";
    readLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:readLabel];
    [readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(readBtn.mas_right).with.offset(10);
        make.centerY.mas_equalTo(readBtn.mas_centerY);
    }];
    
    ProtocolModel *protocol = [_protocolArray firstObject];
    UIButton *protocalBtn = [[UIButton alloc]init];
    [protocalBtn setTitle:protocol.protocolName forState:UIControlStateNormal];
    [protocalBtn setTitleColor:UIColorFromRGB(0x2222ff) forState:UIControlStateNormal];
    protocalBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [protocalBtn addTarget:self action:@selector(clickProtocalBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:protocalBtn];
    [protocalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(readBtn.mas_centerY);
        make.left.mas_equalTo(readLabel.mas_right).with.offset(5);
    }];
    
    
    self.logBtn = [[UIButton alloc]init];
    self.logBtn.layer.masksToBounds = YES;
    self.logBtn.layer.cornerRadius = 6;
    self.logBtn.backgroundColor = MainColor;
    [self.logBtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.logBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.logBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.logBtn addTarget:self action:@selector(clickRegisterBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.logBtn];
    [self.logBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView.mas_left);
        make.right.mas_equalTo(backView.mas_right);
        make.height.mas_equalTo(IS_IPAD ? 55 : 44);
        make.top.mas_equalTo(protocalBtn.mas_bottom).offset(IS_IPAD ? 15 : 10);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    
    if (theTextField.text.length != 0) {
        self.logBtn.backgroundColor = UIColorFromRGB(0xD71629);
        self.logBtn.userInteractionEnabled = YES;
        
    }else if (theTextField.text.length == 0){
        self.logBtn.backgroundColor = UIColorFromRGB(0xDD5C5C);
        self.logBtn.userInteractionEnabled = NO;
    }
    
}
-(void)getAuthCode:(SwiftCountdownButton *)sender {

    if (![GlobleFunction isMobileNumber:self.phoneNumTextField.text]) {
        //手机号不正确,请检查手机号
        NSLog(@"请检查手机号");
        [self showError:self.view message:@"请检查手机号" afterHidden:3];
        return;
    }
    
    sender.maxSecond = 10;
    sender.countdown = YES;
    [self getAuthCodeRequest];
 
}
//点击 已阅读 按钮
-(void)clickReadBtn:(UIButton *)sender {
    
    if (sender.selected == YES) {
        sender.selected = NO;
        self.isRead = NO;
    }else {
        sender.selected = YES;
        self.isRead = YES;
    }
}
//点击 协议内容
-(void)clickProtocalBtn {
    ProtocolModel *model = [_protocolArray firstObject];
    ProtocolPDFViewController *vc = [[ProtocolPDFViewController alloc] init];
    vc.loadURLString = model.protocolPdf;
    vc.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:vc animated:true];
//    ProtocolViewController *vc = [[ProtocolViewController alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    
    
}
//点击 获取验证码
-(void)getAuthCodeRequest {
    
    NSString *url = [NSString stringWithFormat:@"%@v1/user/code?m=%@",DOMAIN_NAME,self.phoneNumTextField.text];
    
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        NSLog(@"返回结果 %@",result);
        if (result != nil) {
           NSLog(@"succeed:msg:%@", result.getMessage);
          if(result.isSucceed){
            NSDictionary *dic = result.getDataObj;
            NSLog(@"%@",dic);
              //验证码
//              self.authCode = [dic objectForKey:@"authCode"];
              //验证码回填
//              self.authCodeTextField.text = self.authCode;
        }
        }else{
            NSLog(@"错误 %@",error);
        }
        
    }]; 
}
//点击  注册
-(void)clickRegisterBtn {
    
    [self.phoneNumTextField resignFirstResponder];
    [self.authCodeTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    if (self.isRead == NO) {
        //请先阅读相关协议
        [self showError:self.view message:@"请先阅读相关协议" afterHidden:3];
        return;
    }

    if (![GlobleFunction isMobileNumber:self.phoneNumTextField.text]) {
        //手机号有误
        [self showError:self.view message:@"请检查手机号" afterHidden:3];
        return;
    }

    if ([self.passwordTextField.text isEqualToString:@""]){
        //密码不能为空
        [self showError:self.view message:@"密码不能为空" afterHidden:3];
        return;
    }
//    if (![self.authCodeTextField.text isEqualToString:self.authCode]) {
//       //验证码有误
//        [self showError:self.view message:@"验证码有误" afterHidden:3];
//        return;
//    }
    [self sendRegisterRequest];
    
}


//注册 网络请求
-(void)sendRegisterRequest {
    
    AINetworkEngine *manager = [AINetworkEngine sharedClient];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"accountName"] = self.phoneNumTextField.text;
    params[@"password"] = self.passwordTextField.text;
    params[@"authCode"] = self.authCodeTextField.text;
//    params[@"chexkbox"] = self.isRead ? @"1": @"0";
//    params[@"type"] = @"-1";
    [manager.requestSerializer setValue:@"app" forHTTPHeaderField:@"source"];
    NSLog(@"%@",params);
//    [AINetworkEngine sharedClient].requestSerializer.va
    [manager postWithApi:API_POST_REGISTER parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
        NSLog(@"%@",result);
        if (result != nil) {
            NSLog(@"succeed:msg:%@", result.getMessage);
            if(result.isSucceed){
                NSLog(@"注册成功 %@",result);
                [self showSuccess:[UIApplication sharedApplication].keyWindow message:@"注册成功" afterHidden:2];
               //注册成功
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                 [self showError:self.view message:result.getMessage afterHidden:3];
            }
        }
    }];
    
    
}
@end

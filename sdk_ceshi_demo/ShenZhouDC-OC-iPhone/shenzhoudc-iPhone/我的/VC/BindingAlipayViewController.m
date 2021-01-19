//
//  BindingAlipayViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/8/14.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BindingAlipayViewController.h"

@interface BindingAlipayViewController ()
@property (strong, nonatomic) UITextField *alipayAccountTF;
@end

@implementation BindingAlipayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"绑定支付宝";
    [self makeUI];
}

- (void)makeUI {
    _alipayAccountTF = [[UITextField alloc]init];
    _alipayAccountTF.placeholder = @"请输入支付宝";
    _alipayAccountTF.keyboardType = UIKeyboardTypeASCIICapable;
    _alipayAccountTF.textColor = UIColorFromRGB(0x333333);
    _alipayAccountTF.font = [UIFont systemFontOfSize:18];
    _alipayAccountTF.borderStyle = UITextBorderStyleNone;
    _alipayAccountTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_alipayAccountTF becomeFirstResponder];
    [self.view addSubview:_alipayAccountTF];
    [_alipayAccountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(84);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH-30);
        make.height.mas_equalTo(40);
    }];
    
    UIView *sepLine = [[UIView alloc] init];
    sepLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:sepLine];
    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_alipayAccountTF.mas_width);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(_alipayAccountTF.mas_bottom);
        make.centerX.mas_equalTo(0);
    }];
    
    UIButton *bindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bindBtn.backgroundColor = MainColor;
    bindBtn.layer.cornerRadius = 6;
    bindBtn.clipsToBounds = true;
    [bindBtn setTitle:@"绑定" forState:UIControlStateNormal];
    [bindBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bindBtn addTarget:self action:@selector(clickBinding) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bindBtn];
    [bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sepLine.mas_bottom).offset(20);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH-30);
        make.height.mas_equalTo(50);
    }];
}

- (void)clickBinding {
    [_alipayAccountTF resignFirstResponder];
    if ([_alipayAccountTF.text isEqualToString:@""]) {
        [self showError:self.view message:@"请输入账号" afterHidden:3];
        return;
    }
    NSString * message = [NSString stringWithFormat:@"确定绑定支付宝账号\"%@\"吗?", _alipayAccountTF.text];
    NoAutorotateAlertController *alertVC = [NoAutorotateAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self bindingAlipay:_alipayAccountTF.text];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:sureAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertVC animated:true completion:^{
            
        }];
    });
}

- (void)bindingAlipay:(NSString *)alipayAccount {
    [self showLoadingToView:self.view];
    NSString *url = API_POST_BINDING_ALIPAY;
    NSDictionary *dict = @{@"userId": [UserModel sharedModel].userId,
                           @"unionId": alipayAccount};
    [[AINetworkEngine sharedClient] postWithApi:url parameters:dict CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            if (result.isSucceed) {
                [self.navigationController popViewControllerAnimated:true];
            } else {
                [self showError:self.view message:result.getMessage afterHidden:2];
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

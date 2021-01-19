//
//  ChargeViewController.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/24.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ChargeViewController.h"
#import "ChoosePaymentViewController.h"
#import "WithdrawChooseViewController.h"

@interface ChargeViewController ()
{
    UILabel *personalAccountLabel;
    UILabel *companyAccountLabel;
}
@property(nonatomic,strong)UITextField *textField;
@end

@implementation ChargeViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //刷新用户基本信息
    [self loadUserBaseInfoRequest];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"我的账户";
    self.view.backgroundColor = UIColorFromRGB(0xECECEC);
    [self makeUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAccount) name:@"paySuccessfullyYet" object:nil];
}
- (void)refreshAccount {
    _textField.text = @"";
    //刷新用户基本信息
    [self loadUserBaseInfoRequest];
}
//获取用户资料
-(void)loadUserBaseInfoRequest {
    
    NSString *url = [NSString stringWithFormat:@"%@v1/user/getUsers?id=%@",DOMAIN_NAME,[UserModel sharedModel].userId];
    NSLog(@"%@",url);
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        
        if (result != nil) {
            NSLog(@"succeed:msg:%@", result.getMessage);
            if(result.isSucceed){
                NSDictionary *dic = result.getDataObj;
                NSLog(@"%@",dic);
                dic = [NSDictionary changeType:dic];
                
                UserBaseInfoModel *model = [UserBaseInfoModel modelWithDictionary:dic];
                [model writeToLocal];
                personalAccountLabel.text = [NSString stringWithFormat:@"%.2f",model.wallet.floatValue];
                companyAccountLabel.text = [NSString stringWithFormat:@"%.2f",model.bankAccount.floatValue];
                
            }
        }else{
            [self showError:self.view message:@"加载用户信息失败" afterHidden:3];
        }
        
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)makeUI {
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(10, NAVIGATION_BAR_HEIGHT+STATUSBARHEIGHT+30, SCREEN_WIDTH-20, 173)];
    topView.backgroundColor = [UIColor whiteColor];
    topView.layer.masksToBounds = YES;
    topView.layer.cornerRadius = 4;
    [self.view addSubview:topView];
    
    UILabel *label = [[UILabel alloc]init];
    label.textColor = UIColorFromRGB(0x333333);
    label.text = @"￥";
    label.adjustsFontSizeToFitWidth = YES;
    label.font = [UIFont boldSystemFontOfSize:34];
    [topView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(topView.mas_left).with.offset(10);
        make.top.mas_equalTo(topView.mas_top).with.offset(25);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    _textField = [[UITextField alloc]init];
    _textField.placeholder = @"请输入金额...";
    _textField.keyboardType = UIKeyboardTypeDecimalPad;
    _textField.textColor = UIColorFromRGB(0x333333);
    _textField.font = [UIFont systemFontOfSize:24];
    _textField.borderStyle = UITextBorderStyleNone;
    [topView addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_right).with.offset(15);
        make.centerY.mas_equalTo(label.mas_centerY);
        make.width.mas_equalTo(SCREEN_WIDTH-70);
        make.height.mas_equalTo(40);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xECECEC);
    [topView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(topView.mas_left);
        make.top.mas_equalTo(_textField.mas_bottom).with.offset(10);
        make.right.mas_equalTo(topView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.textColor = UIColorFromRGB(0x333333);
    label1.text = @"账户：";
    label1.font = [UIFont boldSystemFontOfSize:16];
    [topView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_left);
        make.top.mas_equalTo(line.mas_bottom).with.offset(15);
    }];
    
    personalAccountLabel = [[UILabel alloc]init];
    personalAccountLabel.textColor = UIColorFromRGB(0x1E1E1E);
    if (![UserModel isLogin]) {
        personalAccountLabel.text = @"暂无信息";
    }else{
        personalAccountLabel.text = [NSString stringWithFormat:@"%.2f",[UserBaseInfoModel sharedModel].wallet.floatValue];
    }
    personalAccountLabel.font = [UIFont boldSystemFontOfSize:16];
    [topView addSubview:personalAccountLabel];
    [personalAccountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_right).with.offset(10);
        make.centerY.mas_equalTo(label1.mas_centerY);
    }];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.textColor = UIColorFromRGB(0x333333);
    label2.text = @"押金：";
    label2.font = [UIFont boldSystemFontOfSize:16];
    [topView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_left);
        make.top.mas_equalTo(label1.mas_bottom).with.offset(15);
    }];
    
    companyAccountLabel = [[UILabel alloc]init];
    companyAccountLabel.textColor = UIColorFromRGB(0x1E1E1E);
    if (![UserModel isLogin]) {
        companyAccountLabel.text = @"暂无信息";
    }else{
        companyAccountLabel.text = [NSString stringWithFormat:@"%.2f",[UserBaseInfoModel sharedModel].bankAccount.floatValue];
    }
    companyAccountLabel.font = [UIFont boldSystemFontOfSize:16];
    [topView addSubview:companyAccountLabel];
    [companyAccountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label2.mas_right).with.offset(10);
        make.centerY.mas_equalTo(label2.mas_centerY);
    }];
    
    UIButton *chargeBtn = [[UIButton alloc]init];
    chargeBtn.backgroundColor = MainColor;
    chargeBtn.layer.masksToBounds = YES;
    chargeBtn.layer.cornerRadius = 4;
    [chargeBtn setTitle:@"选择充值方式" forState:UIControlStateNormal];
    [chargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    chargeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [chargeBtn addTarget:self action:@selector(clickRechargebtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chargeBtn];
    [chargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, IS_IPAD ? 55 : 40));
    }];
    
    UIButton *withdrawBtn = [[UIButton alloc]init];
    withdrawBtn.backgroundColor = MainColor;
    withdrawBtn.layer.masksToBounds = YES;
    withdrawBtn.layer.cornerRadius = 4;
    [withdrawBtn setTitle:@"选择提现方式" forState:UIControlStateNormal];
    [withdrawBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    withdrawBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [withdrawBtn addTarget:self action:@selector(clickWithdrawBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:withdrawBtn];
    [withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(chargeBtn.mas_top).offset(-10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, IS_IPAD ? 55 : 40));
    }];
}

- (void)clickWithdrawBtn {
    if (![UserModel isLogin]) {
        [self showError:self.view message:@"您还未登录,不能充值" afterHidden:1.5];
        return;
    }
    if (self.textField.text.length == 0) {
        [self showError:self.view message:@"请填写提现金额" afterHidden:1.5];
        return;
    }
    WithdrawChooseViewController *vc = [[WithdrawChooseViewController alloc] init];
    vc.withdrawMoney = [NSString stringWithFormat:@"%.0f", self.textField.text.floatValue*100];
    vc.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:vc animated:true];
}

//获取订单号和appId，调起支付时使用
- (void)clickRechargebtn {
    
    if (![UserModel isLogin]) {
        [self showError:self.view message:@"您还未登录,不能充值" afterHidden:1.5];
        return;
    }
    
    if (self.textField.text.length == 0) {
        [self showError:self.view message:@"请填写充值金额" afterHidden:1.5];
        return;
    }
    ChoosePaymentViewController *vc = [[ChoosePaymentViewController alloc]init];
    vc.price = [NSString stringWithFormat:@"%.0f", self.textField.text.floatValue*100];
    [self.navigationController pushViewController:vc animated:YES];
    
}



@end

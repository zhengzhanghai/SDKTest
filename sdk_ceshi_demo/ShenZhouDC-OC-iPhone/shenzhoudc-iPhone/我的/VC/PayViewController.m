//
//  PayViewController.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/14.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "PayViewController.h"
#import "NewButton.h"

@interface PayViewController ()

@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择付款方式";
    [self makeUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)makeUI {
    
    NewButton *alipayBtn = [[NewButton alloc]init];
    alipayBtn.backgroundColor = UIColorFromRGB(0x3C7BDA);
    [alipayBtn setImage:[UIImage imageNamed:@"alipayPay"] forState:UIControlStateNormal];
    [alipayBtn setTitle:@"支付宝" forState:UIControlStateNormal];
    [alipayBtn addTarget:self action:@selector(clickAlipayBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:alipayBtn];
    [alipayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10.f);
        make.left.mas_equalTo(10.f);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, 150));
    }];
    
    NewButton *wechatBtn = [[NewButton alloc]init];
    wechatBtn.backgroundColor = UIColorFromRGB(0x93D208);
    [wechatBtn setImage:[UIImage imageNamed:@"pay_wechat"] forState:UIControlStateNormal];
    [wechatBtn setTitle:@"微信" forState:UIControlStateNormal];
    [wechatBtn addTarget:self action:@selector(clickWechatBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wechatBtn];
    [wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(alipayBtn.mas_bottom).with.offset(10);
        make.left.mas_equalTo(10.f);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, 150));
    }];
    
}

- (void)clickWechatBtn {
    
    
}
- (void)clickAlipayBtn {
    
}
@end

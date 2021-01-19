//
//  PayResultViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 17/1/17.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "PayResultViewController.h"

@interface PayResultViewController ()
/** 整个支付结果背景视图 */
@property (strong, nonatomic) UIView *bgView;
/** 支付结果图标视图 */
@property (strong, nonatomic) UIImageView *icon;
/** 支付结果视图（支付成功或者支付失败） */
@property (strong, nonatomic) UILabel *resultLabel;
/** 如果支付成功是订单号码视图,失败时未失败原因视图 */
@property (strong, nonatomic) UILabel *labelOne;
/** 支付方式视图（支付成功时才添加） */
@property (strong, nonatomic) UILabel *paymentLabel;
/** 支付时间视图（支付成功时才添加） */
@property (strong, nonatomic) UILabel *payTimeLabel;
@end

@implementation PayResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initUI];
    [self refresh];
}

- (void)refresh {
    switch (self.payResult) {
        case PayResultTypeSuccess:
        {
            self.icon.image = [UIImage imageNamed:@"pay_success"];
            self.resultLabel.text = @"支付成功";
            self.labelOne.text = @"订单号码:1234567890";
            
            [self.bgView addSubview:self.paymentLabel];
            [self.bgView addSubview:self.payTimeLabel];
            self.paymentLabel.text = @"支付方式:支付宝";
            self.payTimeLabel.text = @"支付时间:2017-01-16";
            
            [self.paymentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.labelOne.mas_bottom).offset(12);
                make.centerX.mas_equalTo(0);
            }];
            [self.payTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.paymentLabel.mas_bottom).offset(12);
                make.centerX.mas_equalTo(0);
            }];

        }
            break;
        case PayResultTypeFailure:
        {
            self.icon.image = [UIImage imageNamed:@"pay_failure"];
            self.resultLabel.text = @"支付失败";
            self.labelOne.text = @"失败原因:未支付";
        }
            break;
            
        default:
        {
            self.icon.image = [UIImage imageNamed:@"pay_failure"];
            self.resultLabel.text = @"未知错误";
        }
            break;
    }
}

- (void)initUI {
    self.view.backgroundColor = UIColorFromRGB(0xF2F2F2);
    
    _bgView = [[UIView alloc] init];
    [self.view addSubview:_bgView];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVBARHEIGHT+STATUSBARHEIGHT+35);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(358);
    }];
    
    [_bgView addSubview:self.icon];
    [_bgView addSubview:self.resultLabel];
    [_bgView addSubview:self.labelOne];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(36);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_bottom).offset(16);
        make.centerX.mas_equalTo(0);
    }];
    [self.labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resultLabel.mas_bottom).offset(36);
        make.centerX.mas_equalTo(0);
    }];
}

#pragma mark: ____视图相关懒加载
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
    }
    return _icon;
}

- (UILabel *)resultLabel {
    if (!_resultLabel) {
        _resultLabel = [[UILabel alloc] init];
        _resultLabel.textColor = UIColorFromRGB(0x333333);
        _resultLabel.font = [UIFont systemFontOfSize:16];
    }
    return _resultLabel;
}

- (UILabel *)labelOne {
    if (!_labelOne) {
        _labelOne = [self createLabel];
    }
    return _labelOne;
}

- (UILabel *)paymentLabel {
    if (!_paymentLabel) {
        _paymentLabel = [self createLabel];
    }
    return _paymentLabel;
}

- (UILabel *)payTimeLabel {
    if (!_payTimeLabel) {
        _payTimeLabel = [self createLabel];
    }
    return _payTimeLabel;
}

- (UILabel *)createLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = UIColorFromRGB(0x666666);
    label.font = [UIFont systemFontOfSize:14];
    
    return label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end

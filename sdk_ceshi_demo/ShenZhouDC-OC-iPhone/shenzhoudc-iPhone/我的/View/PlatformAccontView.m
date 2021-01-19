//
//  PlatformAccontView.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/7/26.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "PlatformAccontView.h"

@interface PlatformAccontView ()
@property (strong, nonatomic) UIView *contentView;
@end

@implementation PlatformAccontView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self makeUI];
    }
    return self;
}

- (void)clickCloseBtn {
    [self removeFromSuperviewWithAnimation];
}

- (void)showAnimation {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [_contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [_contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(SCREEN_WIDTH);
        }];
        [self layoutIfNeeded];
    }];
}

- (void)removeFromSuperviewWithAnimation {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [_contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        [_contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(self.mas_bottom);
            make.width.mas_equalTo(SCREEN_WIDTH);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)makeUI {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    UILabel *accountMessageLabel = [[UILabel alloc] init];
    accountMessageLabel.font = [UIFont boldSystemFontOfSize:20];
    accountMessageLabel.text = @"账户信息";
    accountMessageLabel.numberOfLines = 0;
    accountMessageLabel.textColor = [UIColor blackColor];
    [_contentView addSubview:accountMessageLabel];
    [accountMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(20);
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:normal];
    [closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *bankNameLabel = [[UILabel alloc] init];
    bankNameLabel.font = [UIFont systemFontOfSize:18];
    bankNameLabel.text = @"开户行：中国银行股份有限公司北京银河大街支行";
    bankNameLabel.numberOfLines = 0;
    bankNameLabel.textColor = [UIColor blackColor];
    [_contentView addSubview:bankNameLabel];
    [bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(accountMessageLabel.mas_bottom).offset(20);
    }];
    
    UILabel *companyNameLabel = [[UILabel alloc] init];
    companyNameLabel.font = [UIFont systemFontOfSize:18];
    companyNameLabel.text = @"公司名：北京神州方案云科技有限公司";
    companyNameLabel.numberOfLines = 0;
    companyNameLabel.textColor = [UIColor blackColor];
    [_contentView addSubview:companyNameLabel];
    [companyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(bankNameLabel.mas_bottom).offset(15);
    }];
    
    UILabel *accountLabel = [[UILabel alloc] init];
    accountLabel.font = [UIFont systemFontOfSize:18];
    accountLabel.text = @"账户：318158655801";
    accountLabel.numberOfLines = 0;
    accountLabel.textColor = [UIColor blackColor];
    [_contentView addSubview:accountLabel];
    [accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(companyNameLabel.mas_bottom).offset(15);
    }];
    
    UILabel *alertLabel = [[UILabel alloc] init];
    alertLabel.font = [UIFont systemFontOfSize:15];
    alertLabel.text = @"神州方案云温馨提示\n请您在转账备注中填写提示短信中方案发布受理号，以便平台快速确认。神州方案云提示您不要上当受骗！";
    alertLabel.numberOfLines = 0;
    alertLabel.textAlignment = NSTextAlignmentCenter;
    alertLabel.textColor = [UIColor lightGrayColor];
    [_contentView addSubview:alertLabel];
    [alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(accountLabel.mas_bottom).offset(40);
        make.bottom.mas_equalTo(-30);
    }];
}
@end

//
//  MykeyProjectHeaderView.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/26.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "MykeyProjectHeaderView.h"

@interface MykeyProjectHeaderView ()
@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) UIButton *rightBtn;
@end
@implementation MykeyProjectHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self makeUI];
    }
    return self;
}

- (void)makeUI {
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xEAEAEA);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(1, 30));
    }];
    
    _leftBtn = [[UIButton alloc]init];
    [_leftBtn setTitle:@"已购买" forState:UIControlStateNormal];
    [_leftBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [_leftBtn setTitleColor:UIColorFromRGB(0xD71629) forState:UIControlStateSelected];
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _leftBtn.selected = true;
    [_leftBtn addTarget:self action:@selector(clickLeft) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_leftBtn];
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(line.mas_left);
    }];
    
    
    _rightBtn = [[UIButton alloc]init];
    [_rightBtn setTitle:@"已发布" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [_rightBtn setTitleColor:UIColorFromRGB(0xD71629) forState:UIControlStateSelected];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_rightBtn addTarget:self action:@selector(clickRight) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(line.mas_right);
    }];
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = UIColorFromRGB(0xEAEAEA);
    [self addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)clickLeft {
    _leftBtn.selected = YES;
    _rightBtn.selected = NO;
    if (_clickItemBlock) {
        _clickItemBlock(0);
    }
}

- (void)clickRight {
    _rightBtn.selected = YES;
    _leftBtn.selected = NO;
    if (_clickItemBlock) {
        _clickItemBlock(1);
    }
}

@end

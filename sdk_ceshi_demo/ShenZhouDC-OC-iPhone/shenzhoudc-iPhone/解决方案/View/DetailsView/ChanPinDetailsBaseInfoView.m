//
//  ChanPinDetailsBaseInfoView.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/29.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "ChanPinDetailsBaseInfoView.h"

@interface ChanPinDetailsBaseInfoView()

@property (nonatomic, strong) UILabel         *name;
@property (nonatomic, strong) UILabel         *source;
@property (nonatomic, strong) UILabel         *bianHao;
@property (nonatomic, strong) UILabel         *huoHao;

@end

@implementation ChanPinDetailsBaseInfoView

+ (instancetype)createToSuperView:(UIView *)superView {
    ChanPinDetailsBaseInfoView *view = [[ChanPinDetailsBaseInfoView alloc] init];
    [superView addSubview:view];
    [view initUI];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (void)refresh:(NSString *)title source:(NSString *)source bianHao:(NSString *)bianHao huoHao:(NSString *)huoHao {
    self.name.text = title;
    self.source.text = source;
    self.bianHao.text = [NSString stringWithFormat:@"产品编号:%@", bianHao];
    self.huoHao.text = [NSString stringWithFormat:@"产品货号:%@", huoHao];;
}

- (void)initUI {
    _name = [[UILabel alloc] init];
    [self addSubview:_name];
    _name.font = [UIFont systemFontOfSize:18];
    _name.textColor = UIColorFromRGB(0x484848);
    _name.numberOfLines = 0;
    _name.text = @"";
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(9);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH-30);
        make.height.mas_lessThanOrEqualTo(50);
    }];
    
    _source = [[UILabel alloc] init];
    [self addSubview:_source];
    _source.font = [UIFont systemFontOfSize:14];
    _source.textColor = UIColorFromRGB(0x9B9B9B);
    _source.numberOfLines = 0;
    _source.text = @"";
    [_source mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(_name.mas_bottom).offset(10);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH-30);
        make.height.mas_equalTo(20);
    }];
    
    _bianHao = [[UILabel alloc] init];
    [self addSubview:_bianHao];
    _bianHao.font = [UIFont systemFontOfSize:14];
    _bianHao.textColor = UIColorFromRGB(0x9B9B9B);
    _bianHao.numberOfLines = 0;
    _bianHao.text = @"产品编号:";
    [_bianHao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(_source.mas_bottom);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH/2-15);
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(-9);
    }];
    
    _huoHao = [[UILabel alloc] init];
    [self addSubview:_huoHao];
    _huoHao.font = [UIFont systemFontOfSize:14];
    _huoHao.textColor = UIColorFromRGB(0x9B9B9B);
    _huoHao.numberOfLines = 0;
    _huoHao.text = @"产品货号:";
    [_huoHao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.equalTo(_bianHao.mas_top);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH/2-15);
        make.height.mas_equalTo(20);
    }];
    
}


@end

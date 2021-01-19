//
//  DetailsBaseInfoView.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "DetailsBaseInfoView.h"

@interface DetailsBaseInfoView()
@property (nonatomic, strong) UILabel         *name;
@property (nonatomic, strong) UILabel         *source;
@property (nonatomic, strong) UILabel         *order;
@property (nonatomic, strong) UILabel         *comment;
@property (nonatomic, strong) UILabel         *complaint;

@end


@implementation DetailsBaseInfoView

+ (instancetype)createToSuperView:(UIView *)superView {
    DetailsBaseInfoView *view = [[DetailsBaseInfoView alloc] init];
    [superView addSubview:view];
    [view initUI];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (void)dianZanGesture {
    if (_pingLunBlock) {
        _pingLunBlock(@"1");
    }
}

- (void)caiGesture {
    if (_pingLunBlock) {
        _pingLunBlock(@"2");
    }
}

- (void)clickFavorite {
    if (_favoriteBlock) {
        _favoriteBtn.userInteractionEnabled = false;
        _favoriteBlock();
    }
}

- (void)refresh:(NSString *)title source:(NSString *)source orderCount:(NSString *)orderCount comment:(NSString *)comment complaintCount:(NSString *)complaintCount isFavorite:(BOOL)isFavorite{
    if (title) {
        _name.text = title;
    }
    if (source) {
        _source.text = source;
    }
    if (orderCount) {
        _order.text = orderCount;
    }
    if (comment) {
        _comment.text = comment;
    }
    if (complaintCount) {
        _complaint.text = complaintCount;
    }
    _favoriteBtn.selected = isFavorite;
}

- (void)initUI {
    _name = [[UILabel alloc] init];
    [self addSubview:_name];
    _name.font = [UIFont systemFontOfSize:16];
    _name.textColor = UIColorFromRGB(0x1E1E1E);
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
    
    UIImageView *chengjiao = [[UIImageView alloc] init];
    [self addSubview:chengjiao];
    chengjiao.image = [UIImage imageNamed:@"solu_chengjiao_ed"];
    [chengjiao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(_source.mas_bottom).offset(9);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(13);
        make.bottom.mas_equalTo(-15.f);
    }];
    
    _order = [[UILabel alloc] init];
    [self addSubview:_order];
    _order.font = [UIFont systemFontOfSize:11];
    _order.textColor = UIColorFromRGB(0x979797);
    _order.numberOfLines = 0;
    _order.text = @"";
    [_order mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(chengjiao.mas_right).offset(5);
        make.centerY.equalTo(chengjiao.mas_centerY);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    
    UIImageView *dianZan = [[UIImageView alloc] init];
    [self addSubview:dianZan];
    dianZan.image = [UIImage imageNamed:@"prise_ed"];
    dianZan.userInteractionEnabled = true;
    [dianZan addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dianZanGesture)]];
    [dianZan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_order.mas_right).offset(25.f);
        make.centerY.equalTo(chengjiao.mas_centerY);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(13);
    }];
    
    _comment = [[UILabel alloc] init];
    [self addSubview:_comment];
    _comment.font = [UIFont systemFontOfSize:11];
    _comment.textColor = UIColorFromRGB(0x979797);
    _comment.numberOfLines = 0;
    _comment.text = @"";
    [_comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dianZan.mas_right).offset(5.f);
        make.centerY.equalTo(chengjiao.mas_centerY);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    
    UIImageView *tuCao = [[UIImageView alloc] init];
    [self addSubview:tuCao];
    tuCao.image = [UIImage imageNamed:@"bad_ed"];
    tuCao.userInteractionEnabled = true;
    [tuCao addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(caiGesture)]];
    [tuCao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_comment.mas_right).offset(25.f);
        make.centerY.equalTo(chengjiao.mas_centerY);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(13);
    }];
    
    _complaint = [[UILabel alloc] init];
    [self addSubview:_complaint];
    _complaint.font = [UIFont systemFontOfSize:11];
    _complaint.textColor = UIColorFromRGB(0x979797);
    _complaint.numberOfLines = 0;
    _complaint.text = @"";
    [_complaint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tuCao.mas_right).offset(5.f);
        make.centerY.equalTo(chengjiao.mas_centerY);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    
    _favoriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_favoriteBtn setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
    [_favoriteBtn setImage:[UIImage imageNamed:@"favorite_ed"] forState:UIControlStateSelected];
    [_favoriteBtn addTarget:self action:@selector(clickFavorite) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_favoriteBtn];
    [_favoriteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_complaint.mas_right).offset(25);
        make.centerY.equalTo(chengjiao.mas_centerY);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
}

@end

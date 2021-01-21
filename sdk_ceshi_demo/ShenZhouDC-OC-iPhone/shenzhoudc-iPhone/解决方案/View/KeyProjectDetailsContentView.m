//
//  KeyProjectDetailsContentView.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/26.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "KeyProjectDetailsContentView.h"
#import <SDCycleScrollView/SDCycleScrollView.h>

@interface KeyProjectDetailsContentView ()<SDCycleScrollViewDelegate>
@property (strong, nonatomic) SDCycleScrollView *cycleView;
@property (strong, nonatomic) KeyProjectModel *keyModel;
@end

@implementation KeyProjectDetailsContentView

- (instancetype)initWithFrame:(CGRect)frame keyModel:(KeyProjectModel *)keyModel {
    if ([super initWithFrame:frame]) {
        _keyModel = keyModel;
        [self makeUI];
    }
    return self;
}

- (void)makeUI {
    [self addSubview:self.cycleView];
    self.cycleView.imageURLStringsGroup = _keyModel.iconImg ? @[_keyModel.iconImg]: @[];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = UIColorFromRGB(0x333333);
    titleLabel.text = [NSString stringWithFormat:@"%@", _keyModel.name];
    titleLabel.numberOfLines = 2;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(SCREEN_WIDTH*234/375 + 10);
        make.width.mas_equalTo(SCREEN_WIDTH-30);
    }];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.font = [UIFont systemFontOfSize:14];
    priceLabel.textColor = UIColorFromRGB(0x333333);
    priceLabel.text = [NSString stringWithFormat:@"价格:%.2f元", _keyModel.price.floatValue];
    [self addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(SCREEN_WIDTH-30);
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
    }];
    
    UILabel *despLabel = [[UILabel alloc] init];
    despLabel.font = [UIFont systemFontOfSize:14];
    despLabel.textColor = UIColorFromRGB(0x333333);
    despLabel.numberOfLines = 0;
    despLabel.text = [NSString stringWithFormat:@"描述:%@", _keyModel.desc];
    [self addSubview:despLabel];
    [despLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(SCREEN_WIDTH-30);
        make.top.equalTo(priceLabel.mas_bottom).offset(10);
        if (_keyModel.images && _keyModel.images.count == 0) {
            make.bottom.mas_equalTo(-20);
        }
    }];
    
    for (NSUInteger i = 0; i < _keyModel.images.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = UIColorFromRGB(0xeeeeee);
        [imageView sd_setImageWithURL:[NSURL URLWithString:_keyModel.images[i]] placeholderImage:nil options:SDWebImageProgressiveDownload];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(SCREEN_WIDTH-30);
            make.top.equalTo(despLabel.mas_bottom).offset(i*((SCREEN_WIDTH-30)*0.75+10) + 10);
            make.height.mas_equalTo((SCREEN_WIDTH-30)*0.75);
            if (i == _keyModel.images.count - 1) {
                make.bottom.mas_equalTo(-20);
            }
        }];
    }
}

- (SDCycleScrollView *)cycleView {
    if (!_cycleView) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*234/375) delegate:self placeholderImage:[UIImage imageNamed:@"详情大图默认图"]];
        _cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleView.currentPageDotColor = [UIColor whiteColor];
    }
    return _cycleView;
}
@end

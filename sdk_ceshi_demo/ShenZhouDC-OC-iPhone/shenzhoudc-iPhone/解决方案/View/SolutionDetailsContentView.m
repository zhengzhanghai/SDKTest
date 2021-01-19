//
//  SolutionDetailsContentView.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/12.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "SolutionDetailsContentView.h"

@interface SolutionDetailsContentView ()
@property (strong, nonatomic) PlanDetailsModel *planDetails;
@end

@implementation SolutionDetailsContentView

- (instancetype)initWithFrame:(CGRect)frame planDetails:(PlanDetailsModel *)model {
    if ([super initWithFrame:frame]) {
        _planDetails = model;
        [self makeUI];
    }
    return self;
}

- (void)makeUI {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = UIColorFromRGB(0x333333);
    titleLabel.font = [UIFont systemFontOfSize:16.f];
    titleLabel.text = [NSString stringWithFormat:@"方案名称: %@", _planDetails.name];
    titleLabel.numberOfLines = 0;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16.f);
        make.top.mas_equalTo(15.f);
        make.width.mas_equalTo(SCREEN_WIDTH-32.f);
    }];
    
    UIView *sepline1 = [[UIView alloc] init];
    sepline1.backgroundColor = UIColorFromRGB(0xd8d8d8);
    [self addSubview:sepline1];
    [sepline1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(SCREEN_WIDTH-30);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *keyLabel = [[UILabel alloc] init];
    keyLabel.textColor = UIColorFromRGB(0x333333);
    keyLabel.font = [UIFont systemFontOfSize:16.f];
    keyLabel.text = [NSString stringWithFormat:@"关键词: %@", _planDetails.keyword];
    keyLabel.numberOfLines = 0;
    [self addSubview:keyLabel];
    [keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16.f);
        make.top.equalTo(sepline1.mas_bottom).offset(15.f);
        make.width.mas_equalTo(SCREEN_WIDTH-32.f);
    }];
    
    UIView *sepline2 = [[UIView alloc] init];
    sepline2.backgroundColor = UIColorFromRGB(0xd8d8d8);
    [self addSubview:sepline2];
    [sepline2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(keyLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(SCREEN_WIDTH-30);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *industryLabel = [[UILabel alloc] init];
    industryLabel.textColor = UIColorFromRGB(0x333333);
    industryLabel.font = [UIFont systemFontOfSize:16.f];
    industryLabel.text = @"方案行业分类:";
    industryLabel.numberOfLines = 0;
    [self addSubview:industryLabel];
    [industryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16.f);
        make.top.equalTo(sepline2.mas_bottom).offset(15.f);
        make.width.mas_equalTo(SCREEN_WIDTH-32.f);
    }];
    
    UIView *insdustryBGView = [[UIView alloc] init];
    insdustryBGView.backgroundColor = [UIColor clearColor];
    [self addSubview:insdustryBGView];
    [insdustryBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16.f);
        make.top.equalTo(industryLabel.mas_bottom).offset(5.f);
        make.width.mas_equalTo(SCREEN_WIDTH-32.f);
    }];
    
    UILabel *tmpLabel = nil;
    CGFloat margin = 20.f;
    CGFloat maxX = 0;
    BOOL isLineFeed = false;
    for (NSUInteger i = 0; i < _planDetails.industryName.count; i++) {
        UILabel *insdustryLabel = [[UILabel alloc] init];
        insdustryLabel.textColor = UIColorFromRGB(0x999999);
        insdustryLabel.layer.borderWidth = 0.5;
        insdustryLabel.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
        insdustryLabel.font = [UIFont systemFontOfSize:13];
        insdustryLabel.layer.cornerRadius = 15.f;
        insdustryLabel.textAlignment = NSTextAlignmentCenter;
        insdustryLabel.text = _planDetails.industryName[i];
        [insdustryBGView addSubview:insdustryLabel];
        
        CGFloat labelW = [GlobleFunction computingLabelSizeWith:insdustryLabel.text andWidth:SCREEN_WIDTH andHeight:100.f andFont:insdustryLabel.font].width + 30.f;
        if (maxX + margin + labelW > SCREEN_WIDTH-32.f) {
            isLineFeed = true;
            maxX = 0.f;
        } else {
            isLineFeed = false;
        }
        maxX = maxX + margin + labelW;
        [insdustryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (isLineFeed) {
                make.left.mas_equalTo(0.f);
                make.top.equalTo(tmpLabel.mas_bottom).offset(5.f);
            } else {
                if (i == 0) {
                    make.top.mas_equalTo(10.f);
                    make.left.mas_equalTo(0.f);
                } else {
                    make.top.equalTo(tmpLabel.mas_top);
                    make.left.equalTo(tmpLabel.mas_right).offset(margin);
                }
            }
            make.width.mas_equalTo(labelW);
            make.height.mas_equalTo(30.f);
            if (i == _planDetails.industryName.count - 1) {
                make.bottom.mas_equalTo(-15.f);
            }
            
        }];
        NSLog(@"-------");
        tmpLabel = insdustryLabel;
    }
    
    UIView *sepline3 = [[UIView alloc] init];
    sepline3.backgroundColor = UIColorFromRGB(0xd8d8d8);
    [self addSubview:sepline3];
    [sepline3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(insdustryBGView.mas_bottom).offset(15);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(SCREEN_WIDTH-30);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *caseLabel = [[UILabel alloc] init];
    caseLabel.textColor = UIColorFromRGB(0x333333);
    caseLabel.font = [UIFont systemFontOfSize:16.f];
    caseLabel.text = @"成功案例:";
    caseLabel.numberOfLines = 0;
    [self addSubview:caseLabel];
    [caseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16.f);
        make.top.equalTo(sepline3.mas_bottom).offset(15.f);
        make.width.mas_equalTo(SCREEN_WIDTH-32.f);
    }];
    
    UILabel *caseDespLabel = [[UILabel alloc] init];
    caseDespLabel.textColor = UIColorFromRGB(0x999999);
    caseDespLabel.text = _planDetails.successfulCase;
    caseDespLabel.numberOfLines = 0;
    caseDespLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:caseDespLabel];
    [caseDespLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16.f);
        make.top.equalTo(caseLabel.mas_bottom).offset(10.f);
        make.width.mas_equalTo(SCREEN_WIDTH-32.f);
    }];
    
    UIView *sepline4 = [[UIView alloc] init];
    sepline4.backgroundColor = UIColorFromRGB(0xd8d8d8);
    [self addSubview:sepline4];
    [sepline4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(caseDespLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(SCREEN_WIDTH-30);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *awardsLabel = [[UILabel alloc] init];
    awardsLabel.textColor = UIColorFromRGB(0x333333);
    awardsLabel.font = [UIFont systemFontOfSize:16.f];
    awardsLabel.text = @"获奖情况:";
    awardsLabel.numberOfLines = 0;
    [self addSubview:awardsLabel];
    [awardsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16.f);
        make.top.equalTo(sepline4.mas_bottom).offset(20.f);
        make.width.mas_equalTo(SCREEN_WIDTH-32.f);
    }];
    
    UILabel *awardsDespLabel = [[UILabel alloc] init];
    awardsDespLabel.textColor = UIColorFromRGB(0x999999);
    awardsDespLabel.text = _planDetails.awards;
    awardsDespLabel.font = [UIFont systemFontOfSize:14];
    awardsDespLabel.numberOfLines = 0;
    [self addSubview:awardsDespLabel];
    [awardsDespLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16.f);
        make.top.equalTo(awardsLabel.mas_bottom).offset(10.f);
        make.width.mas_equalTo(SCREEN_WIDTH-32.f);
        make.bottom.mas_equalTo(-30.f);
    }];
}

@end

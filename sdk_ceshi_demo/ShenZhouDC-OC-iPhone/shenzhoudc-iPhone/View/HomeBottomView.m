//
//  HomeBottomView.m
//  shenzhoudc-iPhone
//
//  Created by 郑章海 on 17/2/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "HomeBottomView.h"

@implementation HomeBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self makeSelf];
    }
    return self;
}

- (void)makeSelf {
    self.backgroundColor = [UIColor blackColor];
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:refreshBtn];
    [refreshBtn setImage:[UIImage imageNamed:@"Star"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(35);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(0);
    }];
    
    UIButton *meBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:meBtn];
    [meBtn setImage:[UIImage imageNamed:@"Star"] forState:UIControlStateNormal];
    [meBtn addTarget:self action:@selector(profileClick) forControlEvents:UIControlEventTouchUpInside];
    [meBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-35);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(0);
    }];

}

- (void)refresh {
    NSLog(@"re");
}

- (void)profileClick {
    NSLog(@"pro");
}
@end

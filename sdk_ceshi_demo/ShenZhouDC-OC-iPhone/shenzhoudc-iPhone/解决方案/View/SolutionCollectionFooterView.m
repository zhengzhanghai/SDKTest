//
//  SolutionCollectionFooterView.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/8/21.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "SolutionCollectionFooterView.h"

@implementation SolutionCollectionFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
    
- (void)createUI {
    UIButton *more = [UIButton buttonWithType:UIButtonTypeCustom];
    more.frame = CGRectMake(0, 0, SCREEN_WIDTH, IS_IPAD ? 55 : 40);
    more.backgroundColor = MainColor;
    [more setTitle:@"更多方案" forState:UIControlStateNormal];
    [more setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [more addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:more];
}

- (void)moreClick {
    if (_clickMoreBlock) {
        _clickMoreBlock();
    }
}

@end

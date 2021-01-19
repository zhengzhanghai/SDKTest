//
//  KeyProjectSurePassBottomView.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/27.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "KeyProjectSurePassBottomView.h"
#define TITLES      @[@"取消通过", @"确认通过"]
#define BOARD_WIDTH 0.5

@implementation KeyProjectSurePassBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self makeUI];
    }
    return self;
}

- (void)makeUI {
    CGFloat itemWidth = (SCREEN_WIDTH+(TITLES.count+1)*BOARD_WIDTH)/TITLES.count;
    for (NSUInteger i = 0; i < TITLES.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*itemWidth-(i+1)*BOARD_WIDTH, 0, itemWidth, self.height+0.5);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.layer.borderWidth = BOARD_WIDTH;
        button.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
        button.tag = i;
        [button setTitle:TITLES[i] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)clickItem:(UIButton *)btn {
    if (_clickItemBlock) {
        _clickItemBlock(btn.tag);
    }
}

@end

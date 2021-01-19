//
//  KeyProjectBottomView.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/26.
//  Copyright © 2017年 ;. All rights reserved.
//

#import "KeyProjectBottomView.h"
#define TITLES      @[@"简版方案", @"完整版方案", @"立即购买"]
#define BOARD_WIDTH 0.5

@implementation KeyProjectBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self makeUI];
    }
    return self;
}

- (void)makeUI {
    CGFloat itemWidth = (SCREEN_WIDTH-45)/TITLES.count;
    CGFloat itemHight = IS_IPAD ? 55 : 40;
    for (NSUInteger i = 0; i < TITLES.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(15+i*(itemWidth+7.5), 5, itemWidth, itemHight);
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.layer.cornerRadius = 3;
        button.clipsToBounds = true;
        if ([TITLES[i] isEqualToString:@"立即购买"]) {
            button.backgroundColor = MainColor;
            [button setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        } else {
            button.backgroundColor = UIColorFromRGB(0xf6f6f6);
            [button setTitleColor:UIColorFromRGB(0x1e1e1e) forState:UIControlStateNormal];
        }
        button.tag = i;
        [button setTitle:TITLES[i] forState:UIControlStateNormal];
        
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

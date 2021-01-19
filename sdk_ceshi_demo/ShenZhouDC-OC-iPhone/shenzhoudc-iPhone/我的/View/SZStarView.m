//
//  SZStarView.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/7/6.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "SZStarView.h"

@interface SZStarView ()
@property (copy, nonatomic)   NSArray *btnArray;
@end

@implementation SZStarView
- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        _starStr = @"0";
        [self createUI];
    }
    return self;
}

- (void)createUI {
    NSMutableArray *btns = [NSMutableArray arrayWithCapacity:5];
    for (NSUInteger i = 0; i < 5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*30, 0, 30, 30);
        btn.tag = i;
        [btn setImage:[UIImage imageNamed:@"评价-灰"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"评价-红"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btns addObject:btn];
    }
    _btnArray = btns;
}

- (void)clickBtn:(UIButton *)btn {
    NSInteger index = btn.tag;
    [self setStarWithIndex:index+1];
}

- (void)setStarWithIndex:(NSInteger)index {
    _starStr = [NSString stringWithFormat:@"%zd", index];
    for (NSUInteger i = 0; i < index; i++) {
        UIButton *btn = _btnArray[i];
        btn.selected = true;
    }
    for (NSUInteger i = index; i < 5; i++) {
        UIButton *btn = _btnArray[i];
        btn.selected = false;
    }
}
@end

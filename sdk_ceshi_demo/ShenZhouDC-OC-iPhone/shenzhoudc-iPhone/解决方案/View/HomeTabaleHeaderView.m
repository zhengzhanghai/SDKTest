//
//  HomeTabaleHeaderView.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "HomeTabaleHeaderView.h"
#import "CommonMacro.h"
#import "UIView+Extension.h"
#define BASE_TAG 2315

@interface HomeTabaleHeaderView()
@property (nonatomic, strong) UIButton *currentBtn;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation HomeTabaleHeaderView

- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles {
    if ([super initWithFrame:frame]) {
        [self initSubViews:titles];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)initSubViews:(NSArray *)titles {
    CGFloat edgeMargin = 22;
    CGFloat width = 60;
    CGFloat margin = (SCREEN_WIDTH-edgeMargin*2-width*titles.count)/(titles.count-1);
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        button.frame = CGRectMake(edgeMargin+i*(margin+width), 0, 60, 20);
        button.centerY = self.height/2.0;
        button.tag = BASE_TAG + i;
        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0xD71629) forState:UIControlStateSelected];
        [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            button.selected = YES;
            self.currentBtn = button;
        }
    }
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(edgeMargin, self.height-2.5, 60, 2)];
    _lineView.centerX = edgeMargin+30;
    _lineView.backgroundColor = UIColorFromRGB(0xD71629);
    [self addSubview:_lineView];
    
    UIView *sepLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-0.5, SCREEN_WIDTH, 0.5)];
    [self addSubview:sepLineView];
    sepLineView.backgroundColor = UIColorFromRGB(0x999999);
}

- (void)clickBtn:(UIButton *)btn {
    if (btn == _currentBtn) {
        return;
    }
    _currentBtn.selected = NO;
    btn.selected = YES;
    _currentBtn = btn;
    _lineView.centerX = btn.centerX;
    if (self.titleBlpck) {
        self.titleBlpck(btn.tag-BASE_TAG);
    }
}
@end

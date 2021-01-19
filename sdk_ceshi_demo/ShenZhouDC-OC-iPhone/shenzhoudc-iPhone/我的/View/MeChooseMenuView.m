//
//  MeChooseMenuView.m
//  shenzhoudc-iPhone
//
//  Created by 郑章海 on 2017/9/2.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "MeChooseMenuView.h"

@interface MeChooseMenuView () {
    UIView *_selectedView;
    NSArray *_btnArray;
}

@end
@implementation MeChooseMenuView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles {
    if ([super initWithFrame:frame]) {
        [self createMenuView:titles];
    }
    return self;
}

- (void)clickItem:(UIButton *)btn {
    for (NSUInteger i = 0; i < _btnArray.count; i++) {
        UIButton *btn = _btnArray[i];
        btn.selected = false;
    }
    btn.selected = true;
    if (_clickItemBlock) {
        _clickItemBlock(btn.tag);
    }
    [_selectedView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(2);
        make.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(btn.mas_centerX);
    }];
}

- (void)createMenuView:(NSArray *)titles {
    UIView *sepLine = [[UIView alloc] init];
    sepLine.backgroundColor = UIColorFromRGB(0xb2b2b2);
    [self addSubview:sepLine];
    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    NSMutableArray *btnArr = [NSMutableArray arrayWithCapacity:titles.count];
    for (NSUInteger i = 0; i < titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x1e1e1e) forState:UIControlStateNormal];
        [btn setTitleColor:MainColor forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:IS_IPAD ? 16 : 14];
        btn.tag = i;
        [btn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(IS_IPAD ? 45 : 35);
            make.centerX.mas_equalTo(SCREEN_WIDTH/2/titles.count*(2*i+1)-SCREEN_WIDTH/2);
        }];
        [btnArr addObject:btn];
        if (i == 0) {
            btn.selected = true;
            
            _selectedView = [[UIView alloc] init];
            _selectedView.backgroundColor = MainColor;
            [self addSubview:_selectedView];
            [_selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(56);
                make.height.mas_equalTo(2);
                make.bottom.mas_equalTo(-0.5);
                make.centerX.mas_equalTo(btn.mas_centerX);
            }];
        }
        _btnArray = btnArr;
    }
    
    
    
}
@end

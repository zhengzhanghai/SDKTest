//
//  PaiGongHeaderView.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/5/31.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "PaiGongHeaderView.h"

@interface PaiGongHeaderView()
@property (strong, nonatomic) UIView *bottomLineView;
@property (copy, nonatomic)   NSArray *btnArray;
@end
@implementation PaiGongHeaderView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles {
    if ([super initWithFrame:frame]) {
        _currentIndex = -1;
        self.backgroundColor = UIColorFromRGB(0xeeeeee);
        [self makeUI:titles];
    }
    return self;
}

- (void)makeUI:(NSArray *)titles {
    if (titles && titles.count == 0) {
        return;
    }
    CGFloat btnWidth = self.width/titles.count;
    CGFloat btnHeight = self.height;
    NSMutableArray *muArray = [NSMutableArray arrayWithCapacity:titles.count];
    for (NSUInteger i = 0; i < titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnWidth*i, 0, btnWidth, btnHeight);
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [muArray addObject:btn];
    }
    _btnArray = muArray;
    
    _bottomLineView = [[UIView alloc] init];
    _bottomLineView.frame = CGRectMake(self.width/6-25.f, self.height-10.f, 30.f, 2.f);
    _bottomLineView.backgroundColor = [UIColor redColor];
    [self addSubview:_bottomLineView];
    
    [self clickBtn:[_btnArray firstObject]];
}

- (void)clickBtn:(UIButton *)btn {
    if (btn.tag == _currentIndex) {
        return ;
    }
    _currentIndex = btn.tag;
    [self changeSelectedBtn:_currentIndex];
    if (_clickTitleBlock) {
        _clickTitleBlock(_currentIndex);
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    if (_currentIndex == currentIndex) {
        return ;
    }
    _currentIndex = currentIndex;
    [self changeSelectedBtn:currentIndex];
}

- (void)changeSelectedBtn:(NSUInteger)index {
    for (NSUInteger i = 0; i < _btnArray.count; i++) {
        UIButton *btn =  _btnArray[i];
        btn.selected = false;
    }
    UIButton *btn =  _btnArray[index];
    btn.selected = true;
    _bottomLineView.centerX = btn.centerX;
}
@end

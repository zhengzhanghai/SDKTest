//
//  SolutionCollectionHeaderView.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/8/21.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "SolutionCollectionHeaderView.h"
#define BASE_TAG 2315

@interface SolutionCollectionHeaderView ()
@property (nonatomic, strong) UIButton *currentBtn;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation SolutionCollectionHeaderView
    
- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles {
    if ([super initWithFrame:frame]) {
    [self initSubViews:titles];
    self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self initSubViews:@[@"最新方案" , @"推荐方案",  @"热门方案"]];
    }
    return self;
}
    
- (void)initSubViews:(NSArray *)titles {
    CGFloat width = SCREEN_WIDTH/titles.count;
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        button.frame = CGRectMake(i*width, 0, width, 30);
        button.centerY = self.height/2.0;
        button.tag = BASE_TAG + i;
        button.titleLabel.font = [UIFont systemFontOfSize:IS_IPAD ? 16.0 : 14.0];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x787878) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x1E1E1E) forState:UIControlStateSelected];
        [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            button.selected = YES;
            self.currentBtn = button;
            
            _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-1.5, 60, 1)];
            _lineView.centerX = button.centerX;
            _lineView.backgroundColor = MainColor;
            [self addSubview:_lineView];
        }
    }
    
    
    UIView *sepLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-0.5, SCREEN_WIDTH, 0.5)];
    [self addSubview:sepLineView];
    sepLineView.backgroundColor = UIColorFromRGB(0x787878);
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

//
//  StarView.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "StarView.h"

@interface StarView()
@property (nonatomic, strong) NSMutableArray         *btnArray;
@end

@implementation StarView

+ (instancetype)createToSuperView:(UIView *)superView {
    StarView *starView = [[StarView alloc] init];
    [superView addSubview:starView];
    [starView initUI];
    return starView;
}

- (void)initUI {
    NSMutableArray *btns = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        [button setImage:[UIImage imageNamed:@"pingjia_gray"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"pingjia_red"] forState:UIControlStateSelected];
        button.userInteractionEnabled = NO;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(i*19);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(15);
            make.height.mas_equalTo(15);
        }];
        [btns addObject:button];
    }
    self.btnArray = btns;
}

- (void)star:(NSInteger)stars {
    NSInteger star = stars;
    if (star > 5) {
        star = 5;
    } else if (star < 0) {
        star = 0;
    }
    for (NSInteger i = 0; i < star; i++) {
        UIButton *button = (UIButton *)self.btnArray[i];
        button.selected = YES;
    }
    for (NSInteger i = star; i < 5; i++) {
        UIButton *button = (UIButton *)self.btnArray[i];
        button.selected = NO;
    }
}

- (void)resetStar {
    for (int i = 0; i < 5; i++) {
        UIButton *button = (UIButton *)self.btnArray[i];
        button.selected = NO;
    }
}
@end

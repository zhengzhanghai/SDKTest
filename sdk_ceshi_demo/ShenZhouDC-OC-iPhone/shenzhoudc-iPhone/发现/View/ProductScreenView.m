//
//  ProductScreenView.m
//  shenzhoudc-iPhone
//
//  Created by Harious on 2017/10/9.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ProductScreenView.h"
#import "ProductWheelView.h"

@interface ProductScreenView()

@end

@implementation ProductScreenView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelf)]];
        ProductWheelView *wheelView = [[ProductWheelView alloc] initWithFrame:CGRectMake(self.width-220, self.height - 220, 200, 200)];
        [self addSubview:wheelView];
        wheelView.closeBlock = ^{
            [self removeSelf];
        };
        wheelView.didselectedBlock = ^(NSUInteger index) {
            if (_didSelectedBlock) {
                _didSelectedBlock(index);
            }
            [self removeSelf];
        };
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, TOPBARHEIGHT, SCREEN_WIDTH, CONTENTHEIGHT_NOTOP);
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        }];
    }
    return self;
}

- (void)removeSelf {
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        self.frame = CGRectMake(0, CONTENTHEIGHT_NOTOP, SCREEN_WIDTH, CONTENTHEIGHT_NOTOP);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)makeWheelView {
    
}

@end
